//
//  DDMainADVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainADVC.h"

#if AdMobSDK_Enabled
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif

static NSString *const kMainTabBarCtrlSegueID = @"MainTabBarCtrlSegueID";

@interface DDMainADVC () <GADBannerViewDelegate>
@property (strong, nonatomic) UITabBarController *tabBarCtrl;
@property (weak, nonatomic) IBOutlet UIView *adContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adContainerHeightConstraint;
@property (strong, nonatomic) GADBannerView *adView;
@end

@implementation DDMainADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GADRequest *req = [GADRequest request];
    req.testDevices = @[kGADSimulatorID];
    
    GADAdSize size = GADAdSizeFromCGSize(CGSizeMake(Device_Width, 50.f));
    self.adView = [[GADBannerView alloc] initWithAdSize:size];
#if DEBUG_MODE
    // 谷歌提供的测试广告单元
    self.adView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";
#else
    self.adView.adUnitID = @"ca-app-pub-3317628345096940/6074502516";
#endif
    self.adView.rootViewController = self;
    self.adView.delegate = self;
    
#if TARGET_OS_SIMULATOR
    self.adView.autoloadEnabled = NO;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adView loadRequest:request];
#else
    self.adView.autoloadEnabled = YES;
#endif
    [self.adContainer addSubview:self.adView];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    NSLog(@"收到了ad");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"接收ad失败：%@",error);
}

#pragma mark Click-Time Lifecycle Notifications
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD即将全屏");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD即将退出全屏");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD已经退出全屏");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    NSLog(@"点击AD即将离开应用");
}


- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.tabBarCtrl;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.tabBarCtrl;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMainTabBarCtrlSegueID]) {
        self.tabBarCtrl = segue.destinationViewController;
    }
}

@end
