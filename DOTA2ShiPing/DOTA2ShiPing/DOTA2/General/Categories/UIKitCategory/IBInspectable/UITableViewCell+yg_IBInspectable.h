//
//  UITableViewCell+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UITableViewCell (yg_IBInspectable)
// 可以在IB中设置这个值为YES。使cell的分割线没有边距
@property (assign, nonatomic) IBInspectable BOOL separatorInsetZero_;
// 设置selectedBackgroundView的颜色。默认为nil
@property (strong, nonatomic) IBInspectable UIColor *selectedBackgroundColor_;

@property (assign, nonatomic) IBInspectable NSInteger actionFontSize_;

@end
