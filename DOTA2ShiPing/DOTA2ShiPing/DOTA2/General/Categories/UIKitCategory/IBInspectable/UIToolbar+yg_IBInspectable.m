//
//  UIToolbar+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIToolbar+yg_IBInspectable.h"
#import "ReactiveObjC.h"

static void *lineViewColorKey = &lineViewColorKey;
static void *lineViewHiddenKey = &lineViewHiddenKey;

@implementation UIToolbar (yg_IBInspectable)
YGSwizzleMethod

+ (void)load
{
    SEL oldSel = @selector(layoutSubviews);
    SEL newSel = @selector(yg_layoutSubviews);
    [self swizzleInstanceSelector:oldSel withNewSelector:newSel]; //UIToolbar的子view是后期加进去的
}

- (UIView *)lineView
{
    if (iOS10) {
        
        NSString *className = [NSString stringWithFormat:@"_UIBarB%@ground",@"ack"];
        Class class = NSClassFromString(className);
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:class]) {
                for (UIView *lineView in view.subviews) {
                    if (CGRectGetHeight(lineView.bounds) <= 1.1) {
                        return lineView;
                    }
                }
            }
        }
        return nil;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (CGRectGetHeight(view.bounds) <= 1.1) {
                return view;
            }
        }
    }
    return nil;
}

- (void)yg_layoutSubviews
{
    [self yg_layoutSubviews];
    if (objc_getAssociatedObject(self, lineViewHiddenKey)) {
        [self setLineViewHidden_:self.lineViewHidden_];
    }
    if (objc_getAssociatedObject(self, lineViewColorKey)) {
        [self setLineViewColor_:self.lineViewColor_];
    }
}

- (void)setLineViewHidden_:(BOOL)lineViewHidden_
{
    objc_setAssociatedObject(self, lineViewHiddenKey, @(lineViewHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[self lineView] setHidden:lineViewHidden_];
}

- (BOOL)lineViewHidden_
{
    return [objc_getAssociatedObject(self, lineViewHiddenKey) boolValue];
}

- (void)setLineViewColor_:(UIColor *)lineViewColor_
{
    if (lineViewColor_ && !self.lineViewHidden_) {
        objc_setAssociatedObject(self, lineViewColorKey, lineViewColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UIView *lineView = [self lineView];
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

@end
