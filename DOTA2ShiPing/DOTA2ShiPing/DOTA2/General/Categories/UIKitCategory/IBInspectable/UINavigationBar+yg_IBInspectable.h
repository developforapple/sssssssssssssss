//
//  UINavigationBar+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UINavigationBar (yg_IBInspectable)
// 设置导航栏底部的1px横线是否隐藏。默认为NO，显示横线。
@property (assign, nonatomic) IBInspectable BOOL lineViewHidden_;
// 设置导航栏底部的1px横线颜色。默认为 nil 如果手动设置了navigationBar的shadowImage，此属性不再有效。
// shadowImage 需要和 backgroundImage 一起设置。当不需要backgroundImage时单独设置shadowImage是没有用的。
@property (strong, nonatomic) IBInspectable UIColor *lineViewColor_;
// 设置导航栏底部是否有阴影效果。默认为YES，不显示阴影。
@property (assign, nonatomic) IBInspectable BOOL barShadowHidden_;

/*!
 *  @brief 让barTintColor支持透明度
 *  @brief 默认情况下设置barTintColor的alpha值是无效的，系统会忽略这个alpha值，会使用0.85f作为barTintColor附着的view的alpha。当barTintColor设置为亮色的时候，磨砂效果不明显。
 *  @brief 使用 barTintColorAlpha_ 属性可以修改barTintColor附着的view的alpha值。使磨砂效果可以更加清晰的显示。
 *  @brief 这个属性需要配合 translucent 和 barTintColor 使用。
 *  @brief 这个属性可以使用 UIAppearance 进行全局设置
 */
@property (assign, nonatomic) CGFloat barTintColorAlpha_ UI_APPEARANCE_SELECTOR;
@end
