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
