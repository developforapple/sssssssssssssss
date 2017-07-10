//
//  UISearchBar+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UISearchBar (yg_IBInspectable)
// 设置searchBar的背景颜色。这个背景颜色可以带透明度。使用BarTintColor设置的背景颜色设置透明度无效
@property (strong, nonatomic) IBInspectable UIColor *realBackgroundColor;
// 通过设置backgroundImage的方式来设置背景颜色
@property (strong, nonatomic) IBInspectable UIColor *realBackgroundImageColor;
// 输入框的tintColor
@property (strong, nonatomic) IBInspectable UIColor *textFieldTintColor;

@property (strong, readonly, nonatomic) UITextField *textField;
@property (strong, readonly, nonatomic) UIButton *cancelButton;

@end
