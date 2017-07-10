//
//  UIView+Hierarchy.h
//
//  Created by bo wang on 2017/4/17.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UIView (Hierarchy)

- (__kindof UIView *)superviewWithClass:(Class)cls;

- (UITableView *)superTableView;
- (__kindof UITableViewCell *)superTableViewCell;
- (UICollectionView *)superCollectionView;
- (__kindof UICollectionViewCell *)superCollectionViewCell;

- (BOOL)containView:(UIView *)view;

@end
