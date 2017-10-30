//
//  UIViewController+yg_StatusBarAppearance.h
//  DOTA2ShiPing
//
//  Created by WangBo (developforapple@163.com) on 2017/7/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YGStatusBarControlMode) {
    YGStatusBarControlModeApplication,  //由应用控制
    YGStatusBarControlModeViewCtrl,     //由视图控制器控制
    YGStatusBarControlModeAuto,         //自动控制
};

typedef NS_ENUM(NSUInteger, YGStatusBarStyle) {
    YGStatusBarStyleBlack = 0,   //黑色样式
    YGStatusBarStyleLight = 1,   //白色样式
    YGStatusBarStyleAuto = 2     //自适应。根据导航栏的barStyle决定。如果没有导航栏，为default
};

YG_EXTERN NSString *const kYGStatusBarStyleBlackText;   //@"black" 对应 YGStatusBarStyleBlack
YG_EXTERN NSString *const kYGStatusBarStyleLightText;   //@"light" 对应 YGStatusBarStyleLight
YG_EXTERN NSString *const kYGStatusBarStyleWhiteText;   //@"white" 对应 YGStatusBarStyleLight
YG_EXTERN NSString *const kYGStatusBarStyleAutoText;    //@"auto"  对应 YGStatusBarStyleAuto

/*
 
 控制方式：
 1：由控制器控制状态栏显示
 a. 需要设置info.plist中“View controller-based status bar appearance”为YES，否则将发出断言错误
 b.
 
 2：由UIApplication控制状态栏显示
 
 3：由此分类自动控制
 
 
 */


@interface UIViewController (yg_StatusBarAppearance)

/*
 info.plist中“View controller-based status bar appearance”的值
 */
+ (BOOL)isViewControllerBasedStatusBarAppearance;

/*
 默认情况下：
 isViewControllerBasedStatusBarAppearance 为YES时为 Auto，为 NO 时Application
 isViewControllerBasedStatusBarAppearance 为YES时，不能设置此值为 Application
 isViewControllerBasedStatusBarAppearance 为NO时，只能设置此值为 Application
 不允许的情况下强行设置，将会触发断言错误
 */
@property (class) YGStatusBarControlMode statusBarControlMode;


/*
 设置应用的默认状态栏样式
 如果不设置，使用系统提供的默认样式。系统会根据当前UINavigationBar的Style返回不同的样式
 */
@property (class) UIStatusBarStyle defaultStatusBarStyle;


/*
 设置本控制器对应的状态栏样式。在IB中直接设置。
 */
@property (assign, nonatomic) IBInspectable int statusBarStyle_; //YGStatusBarStyle
/*
 使用文本形式的状态栏样式。方便在IB中直接设置。如果设置了 statusBarStyle_ 则 statusBarStyleText_ 无效
 */
@property (copy, nonatomic) IBInspectable NSString *statusBarStyleText_;

// 设置当前控制器的状态栏是否隐藏。默认为NO
@property (assign, nonatomic) IBInspectable BOOL statusBarHidden_;
// 设置当前控制的状态栏是否亮色。
@property (assign, nonatomic) IBInspectable BOOL statusBarLight_ YG_DEPRECATED(1.0, "");

- (void)updateStatusBarAppearIfNeed;
- (void)updateStatusBarStyleIfNeed;
- (void)updateStatusBarHiddenIfNeed;

@end
