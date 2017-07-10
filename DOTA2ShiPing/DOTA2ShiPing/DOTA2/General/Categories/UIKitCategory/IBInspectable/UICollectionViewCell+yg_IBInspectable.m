//
//  UICollectionViewCell+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UICollectionViewCell+yg_IBInspectable.h"

@implementation UICollectionViewCell (yg_IBInspectable)
- (UIView *)theSelectedBackgroundView
{
    UIView *view = self.selectedBackgroundView;
    if (!view) {
        view = [UIView new];
        self.selectedBackgroundView = view;
    }
    return view;
}

- (void)setSelectedBackgroundColor_:(UIColor *)selectedBackgroundColor_
{
    UIView *view = [self theSelectedBackgroundView];
    view.backgroundColor = selectedBackgroundColor_;
    self.selectedBackgroundView = view;
}

- (UIColor *)selectedBackgroundColor_
{
    return [self theSelectedBackgroundView].backgroundColor;
}

- (void)setSelectedBackgroundCornerRadius:(CGFloat)selectedBackgroundCornerRadius
{
    UIView *view = [self theSelectedBackgroundView];
    view.cornerRadius_ = selectedBackgroundCornerRadius;
    self.selectedBackgroundView = view;
}

- (CGFloat)selectedBackgroundCornerRadius
{
    return [self theSelectedBackgroundView].cornerRadius_;
}
@end
