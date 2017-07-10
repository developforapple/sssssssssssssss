//
//  UICollectionViewCell+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UICollectionViewCell (yg_IBInspectable)
// 设置selectedBackgroundView的颜色。默认为nil
@property (strong, nonatomic) IBInspectable UIColor *selectedBackgroundColor_;
// 设置selectedBackgroundView的圆角。默认为0
@property (assign, nonatomic) IBInspectable CGFloat selectedBackgroundCornerRadius;
@end
