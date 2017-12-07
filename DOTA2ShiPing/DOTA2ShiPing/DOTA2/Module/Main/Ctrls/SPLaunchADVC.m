//
//  SPLaunchADVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPLaunchADVC.h"

@interface SPLaunchADVC ()
//<BaiduMobAdSplashDelegate>
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appTitleBottomConstraint;//默认900
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appTitleCenterYContraint; //默认950
//@property (strong, nonatomic) BaiduMobAdSplash *splash;
//@property (weak, nonatomic) IBOutlet UIView *adContainer;
@end

@implementation SPLaunchADVC

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.splash = [[BaiduMobAdSplash alloc] init];
//    self.splash.delegate = self;
////    self.splash.AdUnitTag = @"2523982";
//    self.splash.AdUnitTag = @"2058492";
//    [self.splash loadAndDisplayUsingContainerView:self.adContainer];
//}
//
//- (void)displayInWindow:(UIWindow *)window
//{
//    UIViewController *vc = window.rootViewController;
//    [vc addChildViewController:self];
//    [vc.view addSubview:self.view];
//    self.view.frame = vc.view.bounds;
//}
//
//- (void)dismiss
//{
//    [UIView animateWithDuration:.4f animations:^{
//        self.view.alpha = 0.f;
//    } completion:^(BOOL finished) {
//        [self removeFromParentViewController];
//        [self.view removeFromSuperview];
//    }];
//}
//
//- (NSString *)publisherId
//{
////    return @"10045f01";
//    return @"ccb60059";
//}
//
//- (BOOL)enableLocation
//{
//    return NO;
//}
//
//- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash
//{
//    SPLog(@"半开屏广告展示成功");
//    
//    [UIView animateWithDuration:.4f animations:^{
//        self.appTitleBottomConstraint.priority = 950;
//        self.appTitleCenterYContraint.priority = 900;
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
//}
//
//- (void)splashDidClicked:(BaiduMobAdSplash *)splash
//{
//    SPLog(@"半开屏广告点击");
////    [self dismiss];
//}
//
//- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
//{
//    SPLog(@"半开屏广告结束展示");
////    [self dismiss];
//}
//
//- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
//{
//    SPLog(@"半开屏广告展示失败");
//    
////    [self dismiss];
//}

@end
