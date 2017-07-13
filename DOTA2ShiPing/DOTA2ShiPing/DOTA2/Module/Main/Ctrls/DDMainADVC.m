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

@interface DDMainADVC () <GADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *adContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adContainerHeightConstraint;
@property (strong, nonatomic) GADBannerView *adView;
@end

@implementation DDMainADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GADRequest *req = [GADRequest request];
    req.testDevices = @[kGADSimulatorID];
    
    self.adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointZero];
    self.adView.frame = self.adContainer.bounds;
#if DEBUG_MODE
    // 谷歌提供的测试广告单元
    self.adView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";
#else
    self.adView.adUnitID = @"ca-app-pub-3317628345096940/6074502516";
#endif
    self.adView.rootViewController = self;
    self.adView.delegate = self;
    self.adView.autoloadEnabled = YES;
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

@end
