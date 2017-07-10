//
//  UIButton+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;


/**
 为UIButton设置不同状态下背景颜色。将会根据颜色设置不同的backgroundImage。
 */
@interface UIButton (yg_IBInspectable)
@property (strong, nonatomic) IBInspectable UIColor *normalBGImageColor_;    
@property (strong, nonatomic) IBInspectable UIColor *highlightBGImageColor_;
@property (strong, nonatomic) IBInspectable UIColor *selectedBGImageColor_;
@property (strong, nonatomic) IBInspectable UIColor *disabledBGImageColor_;
@end
