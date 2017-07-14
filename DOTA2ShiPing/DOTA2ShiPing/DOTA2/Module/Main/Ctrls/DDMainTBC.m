//
//  DDMainTBC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainTBC.h"
#import "SPUpdateViewCtrl.h"

@interface DDMainTBC ()

@end

@implementation DDMainTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[SPUpdateViewCtrl instanceFromStoryboard] show];
}

@end

//@implementation UITabBarController (TabBarHidden)
//
//- (void)setTabBarHidden:(BOOL)hidden
//{
//    [self setTabBarHidden:hidden animate:YES];
//}
//
//- (void)setTabBarHidden:(BOOL)hidden animate:(BOOL)animate
//{
////    if (animate) {
////        [UIView beginAnimations:nil context:NULL];
////        [UIView setAnimationDuration:.2f];
////    }
////    for (UIView *view in self.view.subviews) {
////        if ([view isKindOfClass:[UITabBar class]]) {
////            CGRect frame = view.frame;
////            if (hidden) {
////                view.frame = CGRectMake(CGRectGetMinX(frame),
////                                        DeviceHeight - kADViewHeight,
////                                        CGRectGetWidth(frame),
////                                        CGRectGetHeight(frame));
////            }else{
////                view.frame = CGRectMake(CGRectGetMinX(frame),
////                                        DeviceHeight-CGRectGetHeight(frame) - kADViewHeight,
////                                        CGRectGetWidth(frame),
////                                        CGRectGetHeight(frame));
////            }
////        }else if ([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
//////            CGRect frame = view.frame;
//////            if (hidden) {
//////                view.frame = CGRectMake(CGRectGetMinX(frame),
//////                                        CGRectGetMinY(frame),
//////                                        CGRectGetWidth(frame),
//////                                        DeviceHeight);
//////            }else{
//////                view.frame = CGRectMake(CGRectGetMinX(frame),
//////                                        CGRectGetMinY(frame),
//////                                        CGRectGetWidth(frame),
//////                                        DeviceHeight - 49.f);
//////            }
////        }
////    }
////    if (animate) {
////        [UIView commitAnimations];
////    }
//}
//
//@end
