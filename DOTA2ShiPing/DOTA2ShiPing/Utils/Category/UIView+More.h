//
//  UIView+More.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (More)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)())completion;

// 避免循环引用
+ (void)setView:(UIView *)view hidden:(BOOL)hidden;//默认有动画
+ (void)setView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated;
+ (void)setView:(UIView *)view hidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)())completion;

// 可以加入同时执行的动画
+ (void)setView:(UIView *)view hidden:(BOOL)hidden animation:(void (^)())animation completion:(void (^)())completion;

@end
