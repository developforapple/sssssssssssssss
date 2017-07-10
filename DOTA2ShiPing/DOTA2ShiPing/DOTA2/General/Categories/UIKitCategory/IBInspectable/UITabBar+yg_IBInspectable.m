//
//  UITabBar+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UITabBar+yg_IBInspectable.h"
#import "ReactiveObjC.h"

static void *lineViewColorKey = &lineViewColorKey;
static void *barShadowHiddenKey = &barShadowHiddenKey;

@implementation UITabBar (yg_IBInspectable)
- (UIView *)lineView
{
    if (iOS10) {
        // iOS10 修改了TabBar的视图层次
        NSString *className = [NSString stringWithFormat:@"_UIBarB%@ground",@"ack"];
        Class class = NSClassFromString(className);
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:class]) {
                for (UIView *lineView in view.subviews) {
                    if (CGRectGetHeight(lineView.bounds) <= 1.1f) {
                        return lineView;
                    }
                }
            }
        }
        return nil;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (CGRectGetHeight(view.bounds) <= 1.1f) {
                return view;
            }
        }
    }
    return nil;
}

- (void)setLineViewHidden_:(BOOL)lineViewHidden_
{
    [[self lineView] setHidden:lineViewHidden_];
}

- (BOOL)lineViewHidden_
{
    return [[self lineView] isHidden];
}

- (void)setLineViewColor_:(UIColor *)lineViewColor_
{
    if (!self.lineViewHidden_) {
        objc_setAssociatedObject(self, lineViewColorKey, lineViewColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UIView *lineView = [self lineView];
        
        /*!
         *  @brief 这里不能直接修改颜色。因为在UITabBar内部，lineView的颜色会被系统再次修改。
         *         所以采用监听的方法，当lineView的颜色不一致时进行调整
         */
        
        bingoWeakify(self);
        [RACObserve(lineView, backgroundColor)
         subscribeNext:^(UIColor *x) {
             bingoStrongify(self);
             CGColorRef color1 = x.CGColor;
             CGColorRef color2 = lineViewColor_.CGColor;
             if (!CGColorEqualToColor(color1, color2)) {
                 [[self lineView] setBackgroundColor:lineViewColor_];
             }
         }];
    }
}

- (UIColor *)lineViewColor_
{
    return objc_getAssociatedObject(self, lineViewColorKey);
}

- (BOOL)barShadowHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, barShadowHiddenKey);
    if (!hidden) {
        return YES;
    }
    return hidden.boolValue;
}

- (void)setBarShadowHidden_:(BOOL)barShadowHidden_
{
    if (self.barShadowHidden_ != barShadowHidden_) {
        objc_setAssociatedObject(self, barShadowHiddenKey, @(barShadowHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.layer.shadowColor = kBlueColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(-2.f, -2.f);
        self.layer.shadowOpacity = barShadowHidden_?0.f:.2f;
        self.layer.shadowRadius = 4.f;
    }
}
@end
