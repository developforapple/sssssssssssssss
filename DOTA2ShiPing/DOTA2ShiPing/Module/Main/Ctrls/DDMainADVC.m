//
//  DDMainADVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainADVC.h"
#import "BaiduMobAdView.h"
#import "SPMacro.h"

@interface DDMainADVC () <BaiduMobAdViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *adContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adContainerHeightConstraint;
@property (strong, nonatomic) BaiduMobAdView *adView;

@end

@implementation DDMainADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adView = [[BaiduMobAdView alloc] init];
    self.adView.AdUnitTag = @"2523930";
    self.adView.AdType = BaiduMobAdViewTypeBanner;
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, 0, DeviceWidth, CGRectGetHeight(self.adContainer.bounds));
    [self.adContainer addSubview:self.adView];
    [self.adView start];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSString *)publisherId
{
    return @"10045f01";
}

-(BOOL) enableLocation
{
    return NO;
}

- (void)willDisplayAd:(BaiduMobAdView *)adview
{
    NSLog(@"展示横幅广告");
}

- (void)failedDisplayAd:(BaiduMobFailReason) reason
{
    NSLog(@"横幅广告展示失败：%d",reason);
}

-(void) didAdImpressed
{
     NSLog(@"展示横幅广告成功");
}

-(void) didAdClicked
{
    NSLog(@"点击了横幅广告");
}

-(void) didDismissLandingPage
{
    NSLog(@"点击横幅广告后关闭了广告");
}

@end
