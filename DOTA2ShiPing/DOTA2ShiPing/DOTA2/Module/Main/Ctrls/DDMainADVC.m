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

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"接收ad失败：%@",error);
}

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD即将全屏");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD即将退出全屏");
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    NSLog(@"AD已经退出全屏");
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    NSLog(@"点击AD即将离开应用");
}

@end
