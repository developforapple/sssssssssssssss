//
//  UITableViewCell+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UITableViewCell+yg_IBInspectable.h"
#import "ReactiveObjC.h"

static const void *defaultInsetKey = &defaultInsetKey;
static const void *defaultLayoutMarginsKey = &defaultLayoutMarginsKey;
static const void *actionFontSizeKey = &actionFontSizeKey;

@implementation UITableViewCell (yg_IBInspectable)

- (UIEdgeInsets)defaultInsets
{
    NSValue *v = objc_getAssociatedObject(self, defaultInsetKey);
    if (v) {
        return [v UIEdgeInsetsValue];
    }
    return self.separatorInset;
}

- (void)setDefaultInsets:(UIEdgeInsets)insets
{
    objc_setAssociatedObject(self, defaultInsetKey, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)defaultLayoutMargins
{
    NSValue *v = objc_getAssociatedObject(self, defaultLayoutMarginsKey);
    if (v) {
        return [v UIEdgeInsetsValue];
    }
    return self.separatorInset;
}

- (void)setDefaultLayoutMargins:(UIEdgeInsets)insets
{
    objc_setAssociatedObject(self, defaultLayoutMarginsKey, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSeparatorInsetZero_:(BOOL)separatorInsetZero
{
    if (separatorInsetZero) {
        [self setDefaultInsets:self.separatorInset];
        self.separatorInset = UIEdgeInsetsZero;
        if (iOS8) {
            [self setDefaultLayoutMargins:self.layoutMargins];
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }else{
        self.separatorInset = [self defaultInsets];
        if (iOS8) {
            self.layoutMargins = [self defaultLayoutMargins];
        }
    }
}
- (BOOL)separatorInsetZero_
{
    return UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.separatorInset);
}

- (void)setSelectedBackgroundColor_:(UIColor *)selectedBackgroundColor_
{
    UIView *view = [UIView new];
    view.backgroundColor = selectedBackgroundColor_;
    self.selectedBackgroundView = view;
}

- (UIColor *)selectedBackgroundColor_
{
    return self.selectedBackgroundView.backgroundColor;
}

- (void)setActionFontSize_:(NSInteger)actionFontSize_
{
    objc_setAssociatedObject(self, actionFontSizeKey, @(actionFontSize_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)actionFontSize_
{
    return [objc_getAssociatedObject(self, actionFontSizeKey) integerValue];
}

NO_WARNING_BEGIN(-Wobjc-protocol-method-implementation)
- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    NSNumber *fontSize = objc_getAssociatedObject(self, actionFontSizeKey);
    if (!fontSize || !(state & UITableViewCellStateShowingDeleteConfirmationMask)) return;
    UIFont *font = [UIFont systemFontOfSize:fontSize.doubleValue];
    
    Class cls = NSClassFromString(@"UITableViewCellDeleteConfirmationView");
    UIView *confirmationView;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:cls]) {
            confirmationView = view;
        }
    }
    for (UIButton *btn in [confirmationView subviews]) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn.titleLabel setFont:font];
        }
    }
}
NO_WARNING_END

@end
