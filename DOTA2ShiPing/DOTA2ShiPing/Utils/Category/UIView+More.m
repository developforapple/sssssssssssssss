//
//  UIView+More.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "UIView+More.h"

@implementation UIView (More)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self setHidden:hidden animated:animated completion:nil];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)())completion
{
    [UIView setView:self hidden:hidden animated:animated completion:completion];
}

+ (void)setView:(UIView *)view hidden:(BOOL)hidden
{
    [self setView:view hidden:hidden animated:YES];
}

+ (void)setView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated
{
    [self setView:view hidden:hidden animated:animated completion:nil];
}

+ (void)setView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)())completion
{
    [self setView:view hidden:hidden animated:animated animation:nil completion:completion];
}

+ (void)setView:(UIView *)view hidden:(BOOL)hidden animation:(void (^)())animation completion:(void (^)())completion
{
    [self setView:view hidden:hidden animated:YES animation:animation completion:completion];
}

+ (void)setView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated animation:(void (^)())animation completion:(void (^)())completion
{
    if (!view) return;
    
    if (!animated) {
        [view setHidden:hidden];
        if (completion)completion();
        return;
    }
    
    if (view.hidden == hidden) {
        if (animation) {
            [UIView animateWithDuration:.2f animations:^{
                if (animation) animation();
            } completion:^(BOOL finished) {
                if (completion) completion();
            }];
        }else{
            if (completion)completion();
        }
        return;
    }
    
    CGFloat alpha = view.alpha;
    
    if (hidden) {
        
        [UIView animateWithDuration:.2f animations:^{
            view.alpha = 0.f;
            if (animation) animation();
        } completion:^(BOOL finished) {
            view.hidden = YES;
            view.alpha = alpha;
            
            if (completion)completion();
        }];
        
    }else{
        view.alpha = 0.f;
        view.hidden = NO;
        
        [UIView animateWithDuration:.2f animations:^{
            view.alpha = alpha;
            if (animation) animation();
        } completion:^(BOOL finished) {
            if (completion)completion();
        }];
        
    }
}

@end
