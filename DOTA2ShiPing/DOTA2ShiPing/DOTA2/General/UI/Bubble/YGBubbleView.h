//
//  YGBubbleView.h
//  CDT
//
//  Created by wwwbbat on 2017/5/27.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import UIKit;
#import "YGBubble.h"


@interface YGBubbleView : UIView

// 箭头方向
@property (assign, nonatomic) IBInspectable  YGBubbleDirection direction;
// 支持 top left bottom right
@property (copy, nonatomic) IBInspectable NSString *directionDesc;
// 箭头尺寸
@property (assign, nonatomic) IBInspectable CGSize arrowSize;
// 圆角
@property (assign, nonatomic) IBInspectable CGFloat bubbleRadius;
// 箭头的中轴的偏移距离。默认值为 YGArrowOffsetMid 居中放置
@property (assign, nonatomic) IBInspectable CGFloat arrowOffset;

// 背景颜色
@property (strong, nonatomic) IBInspectable UIColor *bubbleColor;

// 描边颜色
@property (strong, nonatomic) IBInspectable UIColor *bubbleStrokeColor;

// 描边线宽
@property (assign, nonatomic) IBInspectable CGFloat bubbleStrokeLineWidth;

@end
