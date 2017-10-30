//
//  UINavigationController+Convenience.h
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Convenience)

#pragma mark - Stack
// 从栈底开始，找到的第一个目标控制器
- (nullable __kindof UIViewController *)firstOne:(Class)cls;
// 从栈顶开始，找到的第一个目标控制器
- (nullable __kindof UIViewController *)lastOne:(Class)cls;
// 栈中全部目标类型的控制器
- (nullable NSArray *)findAll:(Class)cls;


// 控制器前面的控制器。没找到或者控制器不在堆栈中，返回nil
- (nullable __kindof UIViewController *)previousOne:(UIViewController *)viewCtrl;
// 控制器后面的控制器。没找到或者控制器不在堆栈中，返回nil
- (nullable __kindof UIViewController *)nextOne:(UIViewController *)viewCtrl;
// 控制器前面的全部控制器。控制器不在堆栈中，返回nil。没找到，返回空数组
- (nullable NSArray *)previousAll:(UIViewController *)viewCtrl;
// 控制器后面的控制器。控制器不在堆栈中，返回nil。没找到，返回空数组
- (nullable NSArray *)nextAll:(UIViewController *)viewCtrl;


#pragma mark - Redirect

// 替换栈中的一个控制器。无动画。
- (void)replace:(UIViewController *)viewCtrl to:(UIViewController *)newViewCtrl;

// 退出栈顶控制器，打开新的控制器，默认有动画。如果新的控制器已经在栈中，那么退回到此控制器。
- (void)redirectTopViewCtrlTo:(UIViewController *)viewCtrl;
- (void)redirectTopViewCtrlTo:(UIViewController *)viewCtrl animated:(BOOL)animated;

// pop到指定class的控制器后，push新的控制器，默认有动画
- (void)yg_push:(UIViewController *)viewCtrl afterPopToClass:(Class)popToCls;
- (void)yg_push:(UIViewController *)viewCtrl afterPopToClass:(Class)popToCls animated:(BOOL)animated;

// pop到指定的控制器后，push新的控制器，默认有动画
- (void)yg_push:(UIViewController *)viewCtrl afterPopToViewCtrl:(UIViewController *)popToViewCtrl;
- (void)yg_push:(UIViewController *)viewCtrl afterPopToViewCtrl:(UIViewController *)popToViewCtrl animated:(BOOL)animated;

// pop到指定class之前的控制器后，push新的控制器，默认有动画
- (void)yg_push:(UIViewController *)viewCtrl afterPopOutClass:(Class)popOutCls;
- (void)yg_push:(UIViewController *)viewCtrl afterPopOutClass:(Class)popOutCls animated:(BOOL)animated;

// pop到指定控制器之前的控制器后，push新的控制器，默认有动画
- (void)yg_push:(UIViewController *)viewCtrl afterPopOutViewCtrl:(UIViewController *)popOutViewCtrl;
- (void)yg_push:(UIViewController *)viewCtrl afterPopOutViewCtrl:(UIViewController *)popOutViewCtrl animated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
