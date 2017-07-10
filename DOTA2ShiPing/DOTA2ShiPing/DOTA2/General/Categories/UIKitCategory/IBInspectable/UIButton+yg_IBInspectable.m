//
//  UIButton+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIButton+yg_IBInspectable.h"

static const void *normalBGColorKey = &normalBGColorKey;
static const void *highlightBGColorKey = &highlightBGColorKey;
static const void *selectedBGColorKey = &selectedBGColorKey;
static const void *disabledBGColorKey = &disabledBGColorKey;

// 设置不同状态下的backgroundColor
@implementation UIButton (yg_IBInspectable)
- (UIColor *)normalBGImageColor_
{
    return objc_getAssociatedObject(self, normalBGColorKey);
}

- (void)setNormalBGImageColor_:(UIColor *)normalBGImageColor_
{
    objc_setAssociatedObject(self, normalBGColorKey, normalBGImageColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImage:[UIImage imageWithColor:normalBGImageColor_] forState:UIControlStateNormal];
}

- (UIColor *)highlightBGImageColor_
{
    return objc_getAssociatedObject(self, highlightBGColorKey);
}

- (void)setHighlightBGImageColor_:(UIColor *)highlightBGImageColor_
{
    objc_setAssociatedObject(self, highlightBGColorKey, highlightBGImageColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImage:[UIImage imageWithColor:highlightBGImageColor_] forState:UIControlStateHighlighted];
}

- (UIColor *)selectedBGImageColor_
{
    return objc_getAssociatedObject(self, selectedBGColorKey);
}

- (void)setSelectedBGImageColor_:(UIColor *)selectedBGImageColor_
{
    objc_setAssociatedObject(self, selectedBGColorKey, selectedBGImageColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImage:[UIImage imageWithColor:selectedBGImageColor_] forState:UIControlStateSelected];
}

- (UIColor *)disabledBGImageColor_
{
    return objc_getAssociatedObject(self, disabledBGColorKey);
}

- (void)setDisabledBGImageColor_:(UIColor *)disabledBGImageColor_
{
    objc_setAssociatedObject(self, disabledBGColorKey, disabledBGImageColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBackgroundImage:[UIImage imageWithColor:disabledBGImageColor_] forState:UIControlStateDisabled];
}

@end
