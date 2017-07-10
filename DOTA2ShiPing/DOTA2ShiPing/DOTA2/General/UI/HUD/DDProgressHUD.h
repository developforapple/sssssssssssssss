//
//  DDProgressHUD.h
//  QuizUp
//
//  Created by Normal on 15/6/30.
//  Copyright (c) 2015年 Bo Wang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface DDProgressHUD : MBProgressHUD

- (void)showAutoHiddenHUDWithMessage:(NSString *)message;

+ (void)showAutoHiddenHUDWithMessage:(NSString *)message;

+ (void)showTipsWithMsg:(NSString *)msg;

+ (instancetype)showAnimatedLoadingInView:(UIView *)view;

@end
