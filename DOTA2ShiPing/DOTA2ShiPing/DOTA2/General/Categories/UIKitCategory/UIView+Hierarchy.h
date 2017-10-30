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



/**
 将一个view收缩消失。需要指定收缩相关的约束。进行收缩时将会设置这些约束的值为0。取消收缩时，将会恢复成原状。
 */
@interface UIView (Collapsed)
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *collapsedConstraints;
@property (assign, getter=isCollapsed, nonatomic) BOOL collapsed;
- (void)setCollapsed:(BOOL)collapsed animated:(BOOL)animated;
@end


/**
 执行view收缩时，将会修改相关约束的值为0。trueConstraint保存了其原始值。
 */
@interface NSLayoutConstraint (Collapsed)
@property (assign, nonatomic) CGFloat trueConstant;
@end
