//
//  UISearchBar+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UISearchBar+yg_IBInspectable.h"

static const void *realBackgroundColorKey = &realBackgroundColorKey;
static const void *realBackgroundImageColorKey = &realBackgroundImageColorKey;

@implementation UISearchBar (yg_IBInspectable)
- (void)setRealBackgroundColor:(UIColor *)realBackgroundColor
{
    objc_setAssociatedObject(self, realBackgroundColorKey, realBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGFloat alpha;
    [realBackgroundColor getWhite:NULL alpha:&alpha];
    
    NSString *k = [NSString stringWithFormat:@"%@%@%@",@"UISear",@"chBarBa",@"ckground"];
    Class c = NSClassFromString(k);
    
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:c]) {
                [view2 setBackgroundColor:realBackgroundColor];
                view2.alpha = alpha;
            }
        }
    }
}

- (UIColor *)realBackgroundColor
{
    return objc_getAssociatedObject(self, realBackgroundColorKey);
}

- (void)setRealBackgroundImageColor:(UIColor *)realBackgroundImageColor
{
    objc_setAssociatedObject(self, realBackgroundImageColorKey, realBackgroundImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImage *image = [UIImage imageWithColor:realBackgroundImageColor];
    [self setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (UIColor *)realBackgroundImageColor
{
    return objc_getAssociatedObject(self, realBackgroundImageColorKey);
}

- (void)setTextFieldTintColor:(UIColor *)textFieldTintColor
{
    [[self textField] setTintColor:textFieldTintColor];
}

- (UIColor *)textFieldTintColor
{
    return [[self textField] tintColor];
}

- (UITextField *)textField
{
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UITextField class]]) {
                return (UITextField *)view2;
            }
        }
    }
    return nil;
}

- (UIButton *)cancelButton
{
    for (UIView *view in self.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIButton class]]) {
                return (UIButton *)view2;
            }
        }
    }
    return nil;
}
@end
