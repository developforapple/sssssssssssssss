//
//  UINavigationController+Convenience.h
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UINavigationController (Convenience)

// 从栈底开始，找到第一个目标视图控制器类。
- (__kindof UIViewController *)firstViewControllerOfClass:(Class)cls;
// 返回找到的第一个目标控制器类的索引，没找到返回NSNotFound
- (NSInteger)firstViewControllerIndexOfClass:(Class)cls;

// 返回在目标控制器类之前的所有视图控制器
- (NSArray *)viewControllersBeforeClass:(Class)cls;
// 不超过目标控制器类的所有视图控制器
- (NSArray *)viewControllersBeforeAndIncludeClass:(Class)cls;

// 关闭并且退出当前界面，打开到新界面。默认有动画
- (void)redirectToViewController:(UIViewController *)viewController;
- (void)redirectToViewController:(UIViewController *)viewController animated:(BOOL)animated;

// 用新控制器替换旧控制器。默认有动画
- (void)replaceViewControllr:(UIViewController *)viewController to:(UIViewController *)newViewController;
- (void)replaceViewControllr:(UIViewController *)viewController to:(UIViewController *)newViewController animated:(BOOL)animated;

@end
