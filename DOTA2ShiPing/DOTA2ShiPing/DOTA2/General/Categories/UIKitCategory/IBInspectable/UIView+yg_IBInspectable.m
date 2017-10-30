//
//  UIView+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIView+yg_IBInspectable.h"

static void *horizontalZeroConstraintKey = &horizontalZeroConstraintKey;
static void *verticalZeroConstraintKey = &verticalZeroConstraintKey;

@implementation UIView (yg_IBInspectable)

- (BOOL)masksToBounds_
{
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds_:(BOOL)masksToBounds_
{
    self.layer.masksToBounds = masksToBounds_;
}

- (CGFloat)cornerRadius_
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius_:(CGFloat)cornerRadius_
{
    self.layer.cornerRadius = cornerRadius_;
}

- (UIColor *)borderColor_
{
    CGColorRef c = self.layer.borderColor;
    return c?[UIColor colorWithCGColor:c]:nil;
}

- (void)setBorderColor_:(UIColor *)borderColor_
{
    self.layer.borderColor = borderColor_.CGColor;
}

- (CGFloat)borderWidth_
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth_:(CGFloat)borderWidth_
{
    self.layer.borderWidth = borderWidth_;
}

- (UIColor *)shadowColor_
{
    CGColorRef c = self.layer.shadowColor;
    return c?[UIColor colorWithCGColor:c]:nil;
}

- (void)setShadowColor_:(UIColor *)shadowColor_
{
    self.layer.shadowColor = shadowColor_.CGColor;
}

- (CGFloat)shadowRadius_
{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius_:(CGFloat)shadowRadius_
{
    self.layer.shadowRadius = shadowRadius_;
}

- (float)shadowOpacity_
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity_:(float)shadowOpacity_
{
    self.layer.shadowOpacity = shadowOpacity_;
}

- (CGSize)shadowOffset_
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset_:(CGSize)shadowOffset_
{
    self.layer.shadowOffset = shadowOffset_;
}

#pragma mark Constraint
- (void)setHorizontalZero_:(BOOL)horizontalZero_
{
    NSLayoutConstraint *c = [self horizontalZeroConstraint];
    c.priority = horizontalZero_?999:UILayoutPriorityFittingSizeLevel;
}

- (BOOL)horizontalZero_
{
    return [self horizontalZeroConstraint].priority > UILayoutPriorityFittingSizeLevel;
}

- (void)setVerticalZero_:(BOOL)verticalZero_
{
    NSLayoutConstraint *c = [self verticalZeroConstraint];
    c.priority = verticalZero_?999:UILayoutPriorityFittingSizeLevel;
}

- (BOOL)verticalZero_
{
    return [self verticalZeroConstraint].priority > UILayoutPriorityFittingSizeLevel;
}

- (NSLayoutConstraint *)horizontalZeroConstraint
{
    NSLayoutConstraint *c = objc_getAssociatedObject(self, horizontalZeroConstraintKey);
    if (!c) {
        c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:0];
        c.priority = UILayoutPriorityFittingSizeLevel;
        objc_setAssociatedObject(self, horizontalZeroConstraintKey, c, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:c];
    }
    return c;
}

- (NSLayoutConstraint *)verticalZeroConstraint
{
    NSLayoutConstraint *c = objc_getAssociatedObject(self, verticalZeroConstraintKey);
    if (!c) {
        c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1 constant:0];
        c.priority = UILayoutPriorityFittingSizeLevel;
        objc_setAssociatedObject(self, verticalZeroConstraintKey, c, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:c];
    }
    return c;
}


@end
