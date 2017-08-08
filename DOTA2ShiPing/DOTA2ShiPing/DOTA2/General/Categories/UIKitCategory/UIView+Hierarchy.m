//
//  UIView+Hierarchy.m
//
//  Created by bo wang on 2017/4/17.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

- (__kindof UIView *)superviewWithClass:(Class)cls
{
    if (!cls || ![cls isSubclassOfClass:[UIView class]]) return nil;
    
    if ([self isKindOfClass:cls]) {
        return self;
    }
    
    UIView *view = self.superview;
    while (view && ![view isKindOfClass:cls]) {
        view = view.superview;
    }
    return view;
}

- (UITableView *)superTableView
{
    return [self superviewWithClass:[UITableView class]];
}

- (__kindof UITableViewCell *)superTableViewCell
{
    return [self superviewWithClass:[UITableViewCell class]];
}

- (UICollectionView *)superCollectionView
{
    return [self superviewWithClass:[UICollectionView class]];
}

- (__kindof UICollectionViewCell *)superCollectionViewCell
{
    return [self superviewWithClass:[UICollectionViewCell class]];
}

- (BOOL)containView:(UIView *)view
{
    UIView *theView = view;
    while (theView && theView != self) {
        theView = theView.superview;
    }
    return theView == self;
}

@end

static void *kTrueConstantKey = &kTrueConstantKey;

@interface NSLayoutConstraint (Collapsed)
@property (assign, nonatomic) float trueConstant;
@end
@implementation NSLayoutConstraint (Collapsed)
- (void)setTrueConstant:(float)trueConstant
{
    objc_setAssociatedObject(self, kTrueConstantKey, @(trueConstant), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)trueConstant
{
    NSNumber *v = objc_getAssociatedObject(self, kTrueConstantKey);
    if (!v) {
        return self.constant;
    }
    return v.floatValue;
}
@end

static void *kCollapsedConstraintsKey = &kCollapsedConstraintsKey;
static void *kCollapsedKey = &kCollapsedKey;

@implementation UIView (Collapsed)

- (void)setCollapsedConstraints:(NSArray *)collapsedConstraints
{
    objc_setAssociatedObject(self, kCollapsedConstraintsKey, collapsedConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)collapsedConstraints
{
    return objc_getAssociatedObject(self, kCollapsedConstraintsKey);
}

- (void)setCollapsed:(BOOL)collapsed
{
    objc_setAssociatedObject(self, kCollapsedKey, @(collapsed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateCollapsedConstraints:collapsed];
}

- (BOOL)isCollapsed
{
    return [objc_getAssociatedObject(self, kCollapsedKey) boolValue];
}

- (void)updateCollapsedConstraints:(BOOL)collapsed
{
    if (collapsed) {
        for (NSLayoutConstraint *aConstraint in self.collapsedConstraints) {
            CGFloat curConstant = aConstraint.constant;
            if (curConstant != 0.f) {
                aConstraint.trueConstant = curConstant;
            }
            aConstraint.constant = 0.f;
        }
    }else{
        for (NSLayoutConstraint *aConstraint in self.collapsedConstraints) {
            CGFloat curConstraint = aConstraint.constant;
            if (curConstraint == 0.f) {
                aConstraint.constant = aConstraint.trueConstant;
            }
            aConstraint.trueConstant = aConstraint.constant;
        }
    }
}

@end
