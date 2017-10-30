//
//  UIView+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

// 对应CALayer属性。
@interface UIView (yg_IBInspectable)
@property (assign, nonatomic) IBInspectable BOOL    masksToBounds_;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius_;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth_;
@property (strong, nonatomic) IBInspectable UIColor *borderColor_;
@property (strong, nonatomic) IBInspectable UIColor *shadowColor_;
@property (assign, nonatomic) IBInspectable CGFloat shadowRadius_;
@property (assign, nonatomic) IBInspectable float shadowOpacity_;
@property (assign, nonatomic) IBInspectable CGSize  shadowOffset_;
// 分别设置水平和垂直方向上的长度是否为0。默认条件下不需要设置。
// 当设为YES时，将添加一个优先级999，值为0的约束。
// 所以当需要使用这两个属性来调整UIView的样式时，需要设置UIView的子view的一些约束优先级不能为1000
@property (assign, nonatomic) IBInspectable BOOL horizontalZero_;// 宽度 0
@property (assign, nonatomic) IBInspectable BOOL verticalZero_;// 高度 0


@end
