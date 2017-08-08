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
#import "JZNavigationExtension.h"

#if LeanCloudSDK_Enabled
#import "AVOSCloud.h"
#endif

#if AdMobSDK_Enabled
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif

#import "Chameleon.h"

@interface AppDelegate ()
@property (strong, nonatomic) SPLaunchADVC *adVC;
@property (strong, nonatomic) UIView *test;
@end

@implementation AppDelegate

+ (instancetype)instance
{
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self _setupUIAppearance];
    [self _setupADSplash];
    [self _setup3rdParty];
    return YES;
}

- (void)_setupUIAppearance
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:kTintColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:kTintColor];
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kRedColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
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
}

- (void)_setupADSplash
{
    self.test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 414)];
    [self.window addSubview:self.test];
    
    [GADMobileAds configureWithApplicationID:kAdMobAppID];
}

- (void)_setup3rdParty
{
    [AVOSCloud setAllLogsEnabled:NO];
    [AVOSCloud setVerbosePolicy:kAVVerboseNone];
    [AVOSCloud setApplicationId:kLeanCloudAppID clientKey:kLeanCloudAppKey];
}

- (void)uploadPushToken
{}


@end
