//
//  UINavigationBar+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UINavigationBar+yg_IBInspectable.h"
#import "ReactiveObjC.h"

static void *lineViewColorKey = &lineViewColorKey;
static void *barTintColorAlphaKey = &barTintColorAlphaKey;
static void *barShadowHiddenKey = &barShadowHiddenKey;

@implementation UINavigationBar (yg_IBInspectable)
- (UIView *)lineView
{
    NSString *bgClassStr;
    if (iOS10) {
        bgClassStr = [NSString stringWithFormat:@"_UIBarB%@ground",@"ack"];
    }else{
        bgClassStr = [NSString stringWithFormat:@"_UINa%@ionBarBa%@und",@"vigat",@"ckgro"];
    }
    
    Class bgClass = NSClassFromString(bgClassStr);
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:bgClass]) {
            for (UIView *bgSubView in view.subviews) {
                if (CGRectGetHeight(bgSubView.bounds) <= 1.1f) {
                    return bgSubView;
                }
            }
        }
    }
    return nil;
}

- (UIView *)backgroundView_
{
    @try {
        UIView *view = [self valueForKey:@"_backgroundView"];
        return view;
    } @catch (NSException *exception) {
        return nil;
    }
}

// 设置barTintColor后barTintColor所在的view
- (UIView *)barTintColorEffectView
{
    UIView *view = [self backgroundView_];
    UIView *backdropView = [view.subviews firstObject];
    if (backdropView) {
        UIView *barTintColorView = [[backdropView subviews] lastObject];
        return barTintColorView;
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
    if (!self.lineViewHidden_ && self.lineViewColor_ != lineViewColor_) {
        UIView *lineView = [self lineView];
        
        /*!
         *  @brief 这里不能直接修改颜色。因为在UINavigationBar内部，lineView的颜色会被系统再次修改。
         *         所以采用监听的方法，当lineView的颜色不一致时进行调整
         */
        static void *lineColorDisposableKey = &lineColorDisposableKey;
        RACDisposable *lastDisposable = objc_getAssociatedObject(self, lineColorDisposableKey);
        [lastDisposable dispose];
        
        bingoWeakify(lineView);
        lastDisposable =
        [RACObserve(lineView, backgroundColor)
         subscribeNext:^(UIColor *x) {
             bingoStrongify(lineView);
             CGColorRef color1 = x.CGColor;
             CGColorRef color2 = lineViewColor_.CGColor;
             if (!CGColorEqualToColor(color1, color2)) {
                 lineView.backgroundColor = lineViewColor_;
             }
         }];
        objc_setAssociatedObject(self, lineColorDisposableKey, lastDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIColor *)lineViewColor_
{
    return [self lineView].backgroundColor;
}

- (void)setBarTintColorAlpha_:(CGFloat)barTintColorAlpha_
{
    CGFloat alpha = MAX(0, MIN(1, barTintColorAlpha_));
    objc_setAssociatedObject(self, barTintColorAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.barTintColor) {
        
        /*!
         *  @brief 这里不能直接修改alpha。因为在UINavigationBar内部，alpha值和backgroundColor会被系统再次修改。
         *         所以采用监听的方法，当alpha值和设定的值不一致时进行调整。
         */
        
        UIView *view = [self barTintColorEffectView];
        bingoWeakify(self);
        [RACObserve(view, alpha)
         subscribeNext:^(NSNumber *x) {
             if (x.floatValue != barTintColorAlpha_) {
                 bingoStrongify(self);
                 [[self barTintColorEffectView] setAlpha:barTintColorAlpha_];
             }
         }];
    }
}

- (CGFloat)barTintColorAlpha_
{
    NSNumber *alpha = objc_getAssociatedObject(self, barTintColorAlphaKey);
    if (!alpha) {
        return 0.85f;   //系统默认透明度。
    }
    return alpha.floatValue;
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
        self.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        self.layer.shadowOpacity = barShadowHidden_?0.f:.2f;
        self.layer.shadowRadius = 4.f;
    }
}
@end
