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

#if AdMobSDK_Enabled
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif

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
    return YES;
}

- (void)_setupUIAppearance
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:kRedColor];
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kRedColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    [[UINavigationBar appearance] setBarTintColor:kRedColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kRedColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
//    [[UITextField appearance] setTintColor:[UIColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:kRedColor];
}

- (void)_setupADSplash
{
    self.test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 414)];
    [self.window addSubview:self.test];
    
    [GADMobileAds configureWithApplicationID:kAdMobAppID];
}

- (void)uploadPushToken
{}


@end
