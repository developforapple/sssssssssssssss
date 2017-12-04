//
//  AppDelegate.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "SPLaunchADVC.h"
#import "SPSteamAPI.h"
#import "SPItemImageLoader.h"

#if LeanCloudSDK_Enabled
    #import "AVOSCloud.h"
#endif

#if !TARGET_PRO
    #import <GoogleMobileAds/GoogleMobileAds.h>
    #import "GDTSplashAd.h"
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

@interface AppDelegate ()
@property (strong, nonatomic) SPLaunchADVC *adVC;

#if !TARGET_PRO
@property (strong, nonatomic) GDTSplashAd *ad;
#endif

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
    [self _loadSplashAd];
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
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kRedColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
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
    [Bugly startWithAppId:kBuglyAppID];
    [Bugly setUserIdentifier:Device_UUID];
    [Bugly updateAppVersion:AppBuildVersion];
#endif
    
}

- (void)uploadPushToken
{}

- (void)_loadSplashAd
{
#if !TARGET_PRO
    self.ad = [[GDTSplashAd alloc] initWithAppkey:kTencentGDTAppKey placementId:kTencentGDTLaunchPOSID];
    self.ad.fetchDelay = 3;
    self.ad.delegate = self;
    [self.ad loadAdAndShowInWindow:self.window];
#endif
}

@end


#if !TARGET_PRO
@interface AppDelegate (GDTSplashAd) <GDTSplashAdDelegate>
@end

@implementation AppDelegate (GDTSplashAd)
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"成功展示启动广告");
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"展示启动广告失败！%@",error);
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告进入后台");
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"点击启动广告");
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告将要关闭");
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告已关闭");
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告点击后展示全屏广告页");
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告点击后展示全屏广告页成功");
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告点击后展示全屏广告页将要关闭");
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"启动广告点击后展示全屏广告页已关闭");
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time
{
    NSLog(@"全屏广告还剩%d秒",(int)time);
}

@end
#endif // !TARGET_PRO
