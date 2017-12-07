//
//  YGCoreLocationHelper.m
//  Golf
//
//  Created by bo wang on 16/8/15.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import MapKit;

#import "YGCoreLocationHelper.h"
#import "TQLocationConverter.h"

typedef NS_ENUM(NSUInteger, _YGCoordinateType) {
    _YGCoordinateTypeGCJ,
    _YGCoordinateTypeWGS,
    _YGCoordinateTypeBaidu,
};

static NSString *const kDefaultCoordinateGCJKey = @"kDefaultCoordinateGCJKey";
static NSString *const kDefaultCoordinateWGSKey = @"kDefaultCoordinateWGSKey";
static NSString *const kDefaultCoordinateBaiduKey = @"kDefaultCoordinateBaiduKey";

@interface YGCoreLocationHelper ()<CLLocationManagerDelegate>

@property (strong, readwrite, nonatomic) CLLocationManager *manager;

@property (assign, readwrite, nonatomic) NSTimeInterval lastUpdateTime;

@property (assign, readwrite, getter=isVaild, nonatomic) BOOL valid;
@property (assign, readwrite, getter=isLocating, nonatomic) BOOL locating;
@property (assign, readwrite, nonatomic) BOOL neverLocated;

@property (assign, readwrite, nonatomic) CLLocationCoordinate2D coordinateGCJ;
@property (assign, readwrite, nonatomic) CLLocationCoordinate2D coordinateWGS;
@property (assign, readwrite, nonatomic) CLLocationCoordinate2D coordinateBaidu;
@property (strong, readwrite, nonatomic) NSDictionary *address;
@property (strong, readwrite, nonatomic) NSString *locality;

@property (strong, readwrite, nonatomic) NSError *lastError;

@end

@implementation YGCoreLocationHelper

+ (void)alertIfNotAvailable
{
    if (YGLocationNotDetermined || YGLocationUsable) return;
    
    NSString *alertStriing = @"来电⁺需要获取您的位置，以获取附近的来电设备。请启动定位服务。";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未开启定位服务" message:alertStriing preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self openLocationServiceSetting];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)openLocationServiceSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Instance
+ (instancetype)shared
{
    static YGCoreLocationHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YGCoreLocationHelper alloc] init];
        helper.manager = [[CLLocationManager alloc] init];
        helper.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
        helper.maximumAccuracy = kCLLocationAccuracyKilometer;
        helper.manager.delegate = helper;
        helper.locating = NO;
        helper.neverLocated = YES;
        
        helper.coordinateGCJ = [helper defaultCoordinate:_YGCoordinateTypeGCJ];
        helper.coordinateWGS = [helper defaultCoordinate:_YGCoordinateTypeWGS];
        helper.coordinateBaidu = [helper defaultCoordinate:_YGCoordinateTypeBaidu];

        helper.valid = CLLocationCoordinate2DIsValid(helper.coordinateWGS);
        helper.minimumInterval = 6 * 60 * 60.f;
        helper.lastUpdateTime = [[NSDate distantPast] timeIntervalSince1970];
    });
    return helper;
}

- (void)setMaximumAccuracy:(CLLocationAccuracy)maximumAccuracy
{
    _maximumAccuracy = maximumAccuracy;
    self.manager.desiredAccuracy = maximumAccuracy;
}

- (void)updateLocation
{
    SPLog(@"外部请求刷新位置");
    NSTimeInterval cur = [[NSDate date] timeIntervalSince1970];
    if (cur - self.lastUpdateTime >= self.minimumInterval) {
        if (YGLocationNotDetermined) {
            [self.manager requestWhenInUseAuthorization];
        }else{
            SPLog(@"启动定位");
            self.locating = YES;
            [self.manager startUpdatingLocation];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kYGCoreLocationDidUpdatedNotification object:self];
    }
}

#pragma mark - Cache
- (NSString *)keyForType:(_YGCoordinateType)type
{
    switch (type) {
        case _YGCoordinateTypeGCJ:return kDefaultCoordinateGCJKey;break;
        case _YGCoordinateTypeWGS:return kDefaultCoordinateWGSKey;break;
        case _YGCoordinateTypeBaidu:return kDefaultCoordinateBaiduKey;break;
    }
    return nil;
}

- (CLLocationCoordinate2D)defaultCoordinate:(_YGCoordinateType)type
{
    NSString *v = [[NSUserDefaults standardUserDefaults] objectForKey:[self keyForType:type]];
    if (v && [v isKindOfClass:[NSString class]]) {
        NSArray *components = [v componentsSeparatedByString:@","];
        if (components.count == 2) {
            return CLLocationCoordinate2DMake([[components firstObject] doubleValue], [[components lastObject] doubleValue]);
        }
    }
    return kCLLocationCoordinate2DInvalid;
}

- (void)saveCoordinate:(CLLocationCoordinate2D)coordinate type:(_YGCoordinateType)type
{
    NSString *v = [NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:[self keyForType:type]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateValidProperty
{
    self.valid = CLLocationCoordinate2DIsValid(self.coordinateWGS);
}

#pragma mark - Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
        self.locating = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    SPLog(@"定位结果：");
#if DEBUG_MODE
    for (CLLocation *aLocation in locations) {
        SPLog(@"la: %.8f  long:%.8f",aLocation.coordinate.latitude,aLocation.coordinate.longitude);
    }
#endif
    
    CLLocation *curLocation = [locations lastObject];
    if (!curLocation) return;
    
    CLGeocoder *curGeocoder = [[CLGeocoder alloc] init];
    [curGeocoder reverseGeocodeLocation:curLocation completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (placemark) {
            self.address = placemark.addressDictionary;
            self.locality = placemark.locality;
            [[NSNotificationCenter defaultCenter] postNotificationName:kYGCoreLocationAddressUpdatedNotification object:self];
        }
    }];
    
    CLLocationCoordinate2D coordinate = curLocation.coordinate;
    self.coordinateWGS = coordinate;
    self.coordinateGCJ = [TQLocationConverter transformFromWGSToGCJ:coordinate];
    self.neverLocated = NO;
    self.locating = NO;
    [self updateValidProperty];

    [manager stopUpdatingLocation];
    
    [self saveCoordinate:self.coordinateWGS type:_YGCoordinateTypeWGS];
    [self saveCoordinate:self.coordinateGCJ type:_YGCoordinateTypeGCJ];
    
    self.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYGCoreLocationDidUpdatedNotification object:self];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.lastError = error;
    self.neverLocated = NO;
    self.locating = NO;
    [self updateValidProperty];
    [manager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYGCoreLocationDidUpdatedNotification object:self];
}

@end

CLLocationDegrees const kInvalidDegrees = 1000;

NSString *const kYGCoreLocationDidUpdatedNotification = @"YGCoreLocationDidUpdatedNotification";
NSString *const kYGCoreLocationAddressUpdatedNotification = @"YGCoreLocationAddressUpdatedNotification";
