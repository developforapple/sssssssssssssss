//
//  YGCoreLocationHelper.h
//  Golf
//
//  Created by bo wang on 16/8/15.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import Foundation;
@import CoreLocation;

// 位置服务是否打开
NS_INLINE BOOL _YGLocationEnabled(void){
    return [CLLocationManager locationServicesEnabled];
}
#define YGLocationEnabled _YGLocationEnabled()


// app是否请求过位置服务
NS_INLINE BOOL _YGLocationAvailabilityNotDetermined(void){
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined;
}
#define YGLocationNotDetermined _YGLocationAvailabilityNotDetermined()


// app 是否可以使用位置服务
NS_INLINE BOOL _YGLocationUsable(void){
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}
#define YGLocationUsable _YGLocationUsable()


@interface YGCoreLocationHelper : NSObject

+ (void)alertIfNotAvailable;
+ (void)openLocationServiceSetting;

+ (instancetype)shared;

/**
 最小定位更新时间间隔。默认为 2 小时。
 */
@property (assign, nonatomic) NSTimeInterval minimumInterval;

/**
 上一次刷新时间 没有定位过时为 
 */
@property (assign, readonly, nonatomic) NSTimeInterval lastUpdateTime;

/*!
 *  @brief 最大定位精度。大于这个精度的值忽略不计。默认为 kCLLocationAccuracyKilometer
 */
@property (assign, nonatomic) CLLocationAccuracy maximumAccuracy;

/*!
 *  @brief 定位manager
 */
@property (strong, readonly, nonatomic) CLLocationManager *manager;


/**
 WGS 数据是否有效  GCS 和 Baidu 的坐标时根据WGS换算而来
 */
@property (assign, readonly, getter=isVaild, nonatomic) BOOL valid;

/**
 当前是否正在定位
 */
@property (assign, readonly, getter=isLocating, nonatomic) BOOL locating;

/**
 从未定位过 默认YES
 */
@property (assign, readonly, nonatomic) BOOL neverLocated;

/**
 GPS定位获得的WGS坐标 默认上一次定位数据 从未定位过为 kCLLocationCoordinate2DInvalid
 */
@property (assign, readonly, nonatomic) CLLocationCoordinate2D coordinateWGS;


/**
 实际使用的GCJ坐标 默认上一次定位数据 从未定位过为 kCLLocationCoordinate2DInvalid
 */
@property (assign, readonly, nonatomic) CLLocationCoordinate2D coordinateGCJ;

/**
 百度地图经纬度坐标 默认上一次定位数据 从未定位过为 kCLLocationCoordinate2DInvalid
 */
//@property (assign, readonly, nonatomic) CLLocationCoordinate2D coordinateBaidu;

/**
 定位位置词典
 */
@property (strong, readonly, nonatomic) NSDictionary *address;

/**
 定位城市
 */
@property (strong, readonly, nonatomic) NSString *locality;

@property (strong, readonly, nonatomic) NSError *lastError;

- (void)updateLocation;

@end

FOUNDATION_EXTERN CLLocationDegrees const kInvalidDegrees;

FOUNDATION_EXTERN NSString *const kYGCoreLocationDidUpdatedNotification;
FOUNDATION_EXTERN NSString *const kYGCoreLocationAddressUpdatedNotification;

NS_INLINE double _getCurLatitude(void){
    YGCoreLocationHelper *helper = [YGCoreLocationHelper shared];
    return helper.valid?helper.coordinateGCJ.latitude:kInvalidDegrees;
}
#define YGCurLatitude _getCurLatitude()

NS_INLINE double _getCurLongitude(void){
    YGCoreLocationHelper *helper = [YGCoreLocationHelper shared];
    return helper.valid?helper.coordinateGCJ.longitude:kInvalidDegrees;
}
#define YGCurLongitude _getCurLongitude()



