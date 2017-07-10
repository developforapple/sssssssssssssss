//
//  UITabBar+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UITabBar (yg_IBInspectable)
// 设置TabBar顶部的1px横线是否隐藏。默认为NO，显示横线。
@property (assign, nonatomic) IBInspectable BOOL lineViewHidden_;
// 设置TabBar顶部的1px横线颜色。默认为 nil 如果手动设置了TabBar 的 backgroundImage，此属性不再有效。
// shadowImage 需要和 backgroundImage 一起设置。当不需要 backgroundImage 时单独设置shadowImage是没有用的。
@property (strong, nonatomic) IBInspectable UIColor *lineViewColor_;
// 设置顶部是否有阴影效果。默认为YES，不显示阴影。
@property (assign, nonatomic) IBInspectable BOOL barShadowHidden_;
@end
