//
//  DDProgressHUD.m
//  QuizUp
//
//  Created by Normal on 15/6/30.
//  Copyright (c) 2015年 Bo Wang. All rights reserved.
//

#import "DDProgressHUD.h"
#import "SPMacro.h"
#import "DGActivityIndicatorView.h"

@implementation DDProgressHUD

- (void)showAutoHiddenHUDWithMessage:(NSString *)message
{
    if (!message) {
        self.removeFromSuperViewOnHide = YES;
        [self hide:YES];
        return;
    }
    
    if (!self.superview) {
        UIWindow *w = [UIApplication sharedApplication].keyWindow;
        [w addSubview:self];
    }
    [self show:YES];
    
    self.removeFromSuperViewOnHide = YES;
    self.labelText = message;
    self.mode = MBProgressHUDModeText;
    [self hide:YES afterDelay:1.5];
}

+ (void)showAutoHiddenHUDWithMessage:(NSString *)message
{
//    if ([DDUSM myStatus] != DDUserStatus_Invalid) {
        DDProgressHUD *HUD = [[DDProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [HUD showAutoHiddenHUDWithMessage:message];
//    }
}

+ (void)showTipsWithMsg:(NSString *)msg{
    [self showAutoHiddenHUDWithMessage:msg];
}

+ (instancetype)showAnimatedLoadingInView:(UIView *)view
{
    DGActivityIndicatorView *indicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:AppBarColor size:32.f];
    [indicator startAnimating];
    
    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.opacity = 0.f;
    HUD.customView = indicator;
    return HUD;
}

@end
