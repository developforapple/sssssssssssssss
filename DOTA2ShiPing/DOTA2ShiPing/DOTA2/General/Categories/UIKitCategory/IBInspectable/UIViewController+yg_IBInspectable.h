//
//  UIViewController+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

/*!
 *  @brief 下面5个属性具有默认值。控制器在显示时根据属性值对默认导航栏进行设置。只会影响默认的导航栏，作为view添加的导航栏不受影响
 *         只有需要特殊处理的控制器才需要在IB中设置。否则使用默认值即可。
 */
@interface UIViewController (yg_IBInspectable)

// 忽略列表
// 在忽略列表中的控制器实例不受后面属性的默认值影响。
+ (void)yg_setIgnored:(BOOL)ignored;
+ (BOOL)yg_isIgnored;

// 对默认值进行修改
+ (void)setDefaultInteractivePopEnabled:(BOOL)enabled;
+ (void)setDefaultNavigationBarTranslucent:(BOOL)translucent;
+ (void)setDefaultNavigationBarBlackStyle:(BOOL)black;
+ (void)setDefaultNavigationBarLineHidden:(BOOL)hidden;
+ (void)setDefaultNavigationBarLineColor:(UIColor *)color;
+ (void)setDefaultNavigationBarShadowHidden:(BOOL)hidden;
+ (void)setDefaultNavigationBarTintColor:(UIColor *)color;
+ (void)setDefaultNavigationBarTextColor:(UIColor *)color;

// 设置当前控制器是否支持全屏返回手势。默认为YES，支持手势返回
@property (assign, nonatomic) IBInspectable BOOL interactivePopEnabled_;
// 设置当前控制器的导航栏是否半透明。默认为YES，导航栏半透明
@property (assign, nonatomic) IBInspectable BOOL naviBarTranslucent_;
// 设置当前控制器的导航栏黑色样式。默认为 NO.
@property (assign, nonatomic) IBInspectable BOOL naviBarBlackStyle_;
// 设置当前控制器的导航栏下的1px横线是否隐藏。默认为YES，不显示细线。
@property (assign, nonatomic) IBInspectable BOOL naviBarLineHidden_;
// 设置当前控制器的导航栏下的1px横线的颜色。默认为 e5e5e5 60%
@property (strong, nonatomic) IBInspectable UIColor *naviBarLineColor_;
// 设置控制器导航栏显示时导航栏的标题文字颜色。默认为上一个颜色
@property (strong, nonatomic) IBInspectable UIColor *naviBarTextColor_;
// 设置当前控制器的导航栏下的阴影是否隐藏。默认是YES，不显示阴影。 导航栏不可见或者全透明时将没有阴影。
@property (assign, nonatomic) IBInspectable BOOL naviBarShadowHidden_;

// 设置当前控制器下IQKeyboard是否打开。默认是打开的。
@property (assign, nonatomic) IBInspectable BOOL IQKeyboardEnabled;

@end
