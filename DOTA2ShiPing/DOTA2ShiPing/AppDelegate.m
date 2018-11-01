//
//  AppDelegate.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "SPSteamAPI.h"
#import "SPItemImageLoader.h"
#import "YGRemoteNotificationHelper.h"
#import "SPIAPHelper.h"
#import "SPDataManager.h"
#import "SPDeploy.h"

#if LeanCloudSDK_Enabled
    #import "AVOSCloud.h"
#endif

#if !TARGET_PRO
    #import <GoogleMobileAds/GoogleMobileAds.h>
#endif

#if PgySDK_Enabled
    #import <PgySDK/PgyManager.h>
    #import <PgyUpdate/PgyUpdateManager.h>
#endif

#if BuglySDK_Enabled
    #import <Bugly/Bugly.h>
#endif

@import JZNavigationExtension;
@import FCUUID;
@import ChameleonFramework;
@import SDWebImage;

@interface AppDelegate () <YGRemoteNotificationHelperDelegate>
@end

@implementation AppDelegate

+ (instancetype)instance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _setupUIAppearance];
    [self _setup3rdParty];
    [self _setupNotificaiton:launchOptions];
    [self _setupBackupSetting];
    return YES;
}

- (void)_setupUIAppearance
{
    [[UIBarButtonItem appearance] setTintColor:kTintColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateSelected];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:kTintColor];
    if (iOS11){}else{
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, -65.f) forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setBackIndicatorImage:nil];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:nil];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kTintColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    
    [UIViewController setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    [UIViewController setDefaultNavigationBarTintColor:kBarTintColor];
    [UIViewController setDefaultNavigationBarLineHidden:YES];
    [UIViewController setDefaultNavigationBarTextColor:kTintColor];
    [UIViewController setStatusBarControlMode:YGStatusBarControlModeAuto];
    
    [[UISegmentedControl appearance] setTintColor:kTintColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:kTextColor];
    
    [SVProgressHUD setMinimumDismissTimeInterval:2.f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SDWebImageDownloader sharedDownloader] setDownloadTimeout:60];
}

- (void)_setup3rdParty
{
    [AVOSCloud setAllLogsEnabled:NO];
    [AVOSCloud setVerbosePolicy:kAVVerboseNone];
    [AVOSCloud setApplicationId:kLeanCloudAppID clientKey:kLeanCloudAppKey];
    [self _checkAppDeploy];
    
    // 使用YYMemoryCache 代替 SDWebImage 默认的内存缓存。不修改文件缓存。
    [SPItemImageLoader setSDWebImageUseYYMemoryCache];
    [SDWebImageManager sharedManager].imageDownloader.maxConcurrentDownloads = 20;
    [SDWebImagePrefetcher sharedImagePrefetcher].maxConcurrentDownloads = 4;
    [SDWebImagePrefetcher sharedImagePrefetcher].prefetcherQueue = dispatch_queue_create("SDWebImagePrefetcherQueue", DISPATCH_QUEUE_CONCURRENT);
    
#if !TARGET_PRO
    [GADMobileAds configureWithApplicationID:kAdMobAppID];
#endif
    
#if PgySDK_Enabled
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPgyAppID];
    [PgyManager sharedPgyManager].themeColor = kBarTintColor;
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyAppID];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
#endif
    
#if BuglySDK_Enabled
    BuglyConfig *bc = [BuglyConfig new];
    bc.deviceIdentifier = Device_UUID;
    bc.version = AppBuildVersion;
    bc.channel = kAppChannel;
    bc.blockMonitorEnable = YES;
    bc.unexpectedTerminatingDetectionEnable = YES;
    bc.reportLogLevel = BuglyLogLevelInfo;
    [Bugly startWithAppId:kBuglyAppID config:bc];
    
    #if DEBUG_MODE
        [BuglyLog initLogger:BuglyLogLevelInfo consolePrint:YES];
    #else
        [BuglyLog initLogger:BuglyLogLevelInfo consolePrint:NO];
    #endif
    
#endif //BuglySDK_Enabled
    
}

- (void)_setupNotificaiton:(NSDictionary *)launchOptions
{
    [YGRemoteNotificationHelper shared].delegate = self;
    [[YGRemoteNotificationHelper shared] setup:launchOptions];
    
    if ([SPDataManager isDataValid]) {
        [[YGRemoteNotificationHelper shared] registerNotificationType:YGNotificationTypeAll];
    }
}

- (void)notificationHelper:(YGRemoteNotificationHelper *)helper didReceivedDeviceToken:(NSString *)str
{
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:helper.deviceToken constructingInstallationWithBlock:^(AVInstallation *currentInstallation) {
        
#if TARGET_PRO
        [currentInstallation addUniqueObject:@"Pro" forKey:@"channels"];
#elif TARGET_AD
        [currentInstallation addUniqueObject:@"Ad" forKey:@"channels"];
#else
        [currentInstallation addUniqueObject:@"Old" forKey:@"channels"];
#endif
        if ([SPIAPHelper isPurchased]) {
            [currentInstallation addUniqueObject:@"Pur" forKey:@"channels"];
        }
        [currentInstallation setObject:Device_UUID forKey:@"UUID"];
        [currentInstallation setObject:@YES forKey:@"On"];
        
        SPLog(@"注册APNS成功");
        SPLog(@"DeviceToken:%@",str);
        SPLog(@"UUID:%@",Device_UUID);
    }];
}

- (void)notificationHelper:(YGRemoteNotificationHelper *)helper didReceivedRemoteNotification:(NSDictionary *)userInfo
{
    SPLog(@"收到推送通知：%@",userInfo);
}

- (void)_setupBackupSetting
{
    NSURL *url = [NSURL fileURLWithPath:AppDocumentsPath];
    [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

- (void)_checkAppDeploy
{
    [[SPDeploy instance] update];
}

@end
