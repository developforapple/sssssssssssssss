//
//  DDProgressHUD.m
//  QuizUp
//
//  Created by Normal on 15/6/30.
//  Copyright (c) 2015年 Bo Wang. All rights reserved.
//

#import "DDProgressHUD.h"

#import "DGActivityIndicatorView.h"

@implementation DDProgressHUD

- (void)showAutoHiddenHUDWithMessage:(NSString *)message
{
    if (!message) {
        self.removeFromSuperViewOnHide = YES;
        [self hideAnimated:YES];
        return;
    }
    
    if (!self.superview) {
        UIWindow *w = [UIApplication sharedApplication].keyWindow;
        [w addSubview:self];
    }
    [self showAnimated:YES];
    
    self.removeFromSuperViewOnHide = YES;
    self.label.text = message;
    self.mode = MBProgressHUDModeText;
    [self hideAnimated:YES afterDelay:1.5];
}

+ (void)showAutoHiddenHUDWithMessage:(NSString *)message
{
//    if ([DDUSM myStatus] != DDUserStatus_Invalid) {
    
        DDProgressHUD *HUD = [[DDProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        [HUD showAutoHiddenHUDWithMessage:message];
//    }
}

+ (void)showTipsWithMsg:(NSString *)msg{
    [self showAutoHiddenHUDWithMessage:msg];
}

+ (instancetype)showAnimatedLoadingInView:(UIView *)view
{
    DGActivityIndicatorView *indicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:kRedColor size:32.f];
    [indicator startAnimating];
    
    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor clearColor];
    HUD.customView = indicator;
    return HUD;
}

@end
