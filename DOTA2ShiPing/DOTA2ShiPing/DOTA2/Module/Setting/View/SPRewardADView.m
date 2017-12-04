//
//  SPRewardADView.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/2.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPRewardADView.h"

#if AdMobSDK_Enabled
    @import GoogleMobileAds;

@interface SPRewardADView () <GADInterstitialDelegate>
@property (strong, nonatomic) GADInterstitial *ad;
@end
#endif

@implementation SPRewardADView

#if AdMobSDK_Enabled
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.ad = [[GADInterstitial alloc] initWithAdUnitID:kAdMobLaunchADUnitID];
    self.ad.delegate = self;
    [self.ad loadRequest:[GADRequest request]];
}

- (IBAction)showAD:(id)sender
{
    if (self.ad.isReady) {
        [self.ad presentFromRootViewController:[self viewController]];
    }else{
        [SVProgressHUD showInfoWithStatus:@"没有视频广告"];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"加载激励广告失败：%@",error);
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"收到激励广告");
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"打开激励广告");
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"打开激励广告失败！");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    NSLog(@"激励广告将被移除");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    NSLog(@"激励广告已移除");
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    NSLog(@"点击了激励广告，离开应用");
}
#endif

@end
