//
//  AppDelegate.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "SPMacro.h"
#import "BaiduMobAdSplash.h"
#import "SPLaunchADVC.h"
#import "SPSteamAPI.h"
#import "JZNavigationExtension.h"

#import "UMCommunity.h"
#import "UMComSession.h"

@interface AppDelegate ()<BaiduMobAdSplashDelegate>
@property (strong, nonatomic) BaiduMobAdSplash *splash;
@property (strong, nonatomic) SPLaunchADVC *adVC;

@property (strong, nonatomic) UIView *test;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self _setupUIAppearance];
    [self _setupADSplash];
    
    
    [UMComSession openLog:YES];
    [UMCommunity setAppKey:UMengCommunityKey withAppSecret:UMengCommunityScret];
    
    return YES;
}

- (void)_setupUIAppearance
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:AppBarItemColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:AppBarColor];
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:AppBarColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:AppBarItemColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    [[UINavigationBar appearance] setBarTintColor:AppBarColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:AppBarColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITextField appearance] setTintColor:AppTextFocusColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:AppBarColor];
}

- (void)_setupADSplash
{
    self.test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 414)];
    [self.window addSubview:self.test];
    
    self.splash = [[BaiduMobAdSplash alloc] init];
    self.splash.delegate = self;
    self.splash.AdUnitTag = @"2058492";
    [self.splash loadAndDisplayUsingContainerView:self.test];
    
//    self.adVC = [SPLaunchADVC instanceFromStoryboard];
//    [self.adVC displayInWindow:self.window];
    
//    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
//    splash.delegate = self;
//    splash.AdUnitTag = @"2523963";
//    [splash loadAndDisplayUsingKeyWindow:self.window];
//    self.splash = splash;
}

- (NSString *)publisherId
{
//    return @"10045f01";
    return @"ccb60059";
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    NSLog(@"");
}

@end
