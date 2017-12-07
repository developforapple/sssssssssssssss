//
//  DDMainADVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainADVC.h"
#import "SPConfigManager.h"
#import "SPIAPHelper.h"
@import AVOSCloud.AVAnalytics;

#if TARGET_PRO
    @interface GADBannerView : UIView
    @end
    @implementation GADBannerView
    @end
#else
    #import <GoogleMobileAds/GoogleMobileAds.h>
    #import "GDTMobBannerView.h"
#endif

static NSString *const kMainTabBarCtrlSegueID = @"MainTabBarCtrlSegueID";

@interface DDMainADVC ()

#if !TARGET_PRO
<
    GADAdSizeDelegate,
    GADBannerViewDelegate,
    GDTMobBannerViewDelegate
>
#endif
{
    BOOL _tabCtrlSetConstraintFlag;
}

@property (weak, nonatomic) IBOutlet UIView *mainContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainContainerFullSizeConstraint;
@property (strong, nonatomic) UITabBarController *tabBarCtrl;

@property (weak, nonatomic) IBOutlet UIView *adView;

#if TARGET_PRO
@property (weak, nonatomic) IBOutlet UIView *googleAd;
#else
@property (weak, nonatomic) IBOutlet GADBannerView *googleAd;
@property (strong, nonatomic) GDTMobBannerView *tencentAd;
#endif

@property (assign, nonatomic) BOOL googleAdReady;
@property (assign, nonatomic) BOOL tencentAdReady;
@end

@implementation DDMainADVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseUpdate:) name:kSPPurchaseUpdateNotification object:nil];
    
    if ([self shouldLoadAd]) {

#if !TARGET_PRO
        self.googleAd.autoloadEnabled = YES;
        self.googleAd.adUnitID = kAdMobBannerUnitID;

        self.tencentAd = [[GDTMobBannerView alloc] initWithFrame:self.adView.bounds
                                                          appkey:kTencentGDTAppKey
                                                     placementId:kTencentGDTBannerPOSID];
        self.tencentAd.currentViewController = self;
        self.tencentAd.delegate = self;
        self.tencentAd.isGpsOn = YES;
        [self.tencentAd loadAdAndShow];
        [self addTencentAdConstraint];
#endif
        
    }else{
        
#if !TARGET_PRO
        self.googleAd.autoloadEnabled = NO;
#endif
        
    }
    [self updateAdView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 这里加约束，当adview隐藏和显示切换的时候，顶部tabController的内容区域也相应变化
    if ([self shouldLoadAd]) {
        if (!_tabCtrlSetConstraintFlag) {
            _tabCtrlSetConstraintFlag = YES;
            RunAfter(.5f, ^{
                [self addTabBarCtrlConstraint];
            });
        }
    }
}

- (void)addTencentAdConstraint
{
#if !TARGET_PRO
    [self.adView addSubview:self.tencentAd];
    self.tencentAd.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.tencentAd}]];
    [self.adView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.tencentAd}]];
#endif
}

- (void)addTabBarCtrlConstraint
{
    UIView *view = self.tabBarCtrl.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (view.superview == self.mainContainer) {
        [UIView performWithoutAnimation:^{
            [self.mainContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":view}]];
            [self.mainContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":view}]];
        }];
    }
}

- (void)purchaseUpdate:(NSNotification *)noti
{
    [self updateAdView];
}

- (BOOL)shouldLoadAd
{
#if TARGET_PRO
    return NO;
#elif InHouseVersion
    return NO;
#else
    return !IS_5_8_INCH_SCREEN && ![SPIAPHelper isPurchased];
#endif
}

- (BOOL)isAdReady
{
    return self.googleAdReady || self.tencentAdReady;
}

- (void)setAdViewDisplay:(BOOL)display
{
    [UIView animateWithDuration:.2f animations:^{
        self.mainContainerFullSizeConstraint.priority = display ? 200 : 900;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)updateAdView
{
    if ([self shouldLoadAd]) {
        SPLog(@"app带广告！");
#if !TARGET_PRO
        [self setAdViewDisplay:[self isAdReady]];
        
        if (self.googleAdReady) {
            SPLog(@"Google广告就位");
            [self.adView bringSubviewToFront:self.googleAd];
        }else if (self.tencentAdReady){
            SPLog(@"广点通广告就位");
            [self.adView bringSubviewToFront:self.tencentAd];
        }else{
            SPLog(@"没有可显示的广告内容");
        }
        [self.adView setHidden:NO animated:YES];
#endif
    }else{
        SPLog(@"app不带广告！");
        [self setAdViewDisplay:NO];
        [self.adView setHidden:YES];
    }
}

#if !TARGET_PRO

#pragma mark - ADMob Delegate
- (void)adView:(GADBannerView *)bannerView willChangeAdSizeTo:(GADAdSize)size
{
    
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    SPLog(@"收到了ad");
    self.googleAdReady = YES;
    [self updateAdView];
    
    SPBP(Event_AdMob, Label_AdMob_Received);
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    SPLog(@"接收ad失败：%@",error);
    self.googleAdReady = NO;
    [self updateAdView];
    
    SPBP(Event_AdMob, Label_AdMob_Failed);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    SPLog(@"AD即将全屏");
    SPBP(Event_AdMob, Label_AdMob_Present);
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    SPLog(@"AD即将退出全屏");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    SPLog(@"AD已经退出全屏");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    SPLog(@"点击AD即将离开应用");
    SPBP(Event_AdMob, Label_AdMob_Tapped);
}

#pragma mark - GDT
- (void)bannerViewMemoryWarning
{
    SPLog(@"GDT Banner 内存警告");
}

- (void)bannerViewDidReceived
{
    SPLog(@"GDT Banner 收到了广告");
    self.tencentAdReady = YES;
    [self updateAdView];
    SPBP(Event_GDT, Label_GDT_Received);
}

- (void)bannerViewFailToReceived:(NSError *)error
{
    SPLog(@"GDT Banner 接收广告失败！%@",error);
    self.tencentAdReady = NO;
    [self updateAdView];
    SPBP(Event_GDT, Label_GDT_Failed);
}

- (void)bannerViewWillLeaveApplication
{
    SPLog(@"GDT Banner 点击广告离开应用");
    SPBP(Event_GDT, Label_GDT_Tapped);
}

- (void)bannerViewWillClose
{
    SPLog(@"GDT Banner 被手动关闭");
}

- (void)bannerViewWillExposure
{
    SPLog(@"GDT Banner 曝光回调");
}

- (void)bannerViewClicked
{
    SPLog(@"GDT Banner 被点击");
}

- (void)bannerViewWillPresentFullScreenModal
{
    SPLog(@"GDT Banner 被点击 将要显示全屏广告页");
    SPBP(Event_GDT, Label_GDT_Present);
}

- (void)bannerViewDidPresentFullScreenModal
{
    SPLog(@"GDT Banner 被点击 已显示全屏广告页");
}

- (void)bannerViewWillDismissFullScreenModal
{
    SPLog(@"GDT Banner 全屏广告页 将被关闭");
}

- (void)bannerViewDidDismissFullScreenModal
{
    SPLog(@"GDT Banner 全屏广告页 已关闭");
}
#endif // !TARGET_PRO

#pragma mark -
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
