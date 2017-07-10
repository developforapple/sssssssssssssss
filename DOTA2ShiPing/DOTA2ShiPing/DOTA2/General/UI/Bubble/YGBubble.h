//
//  YGIMBubble.h
//  Golf
//
//  Created by bo wang on 2017/2/4.
//  Copyright © 2017年 云高科技. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, YGBubbleDirection) {
    YGBubbleDirectionTop,
    YGBubbleDirectionLeft,
    YGBubbleDirectionBottom,
    YGBubbleDirectionRight
};

typedef CGFloat YGArrowWidth;      //指箭头两脚的距离
typedef CGFloat YGArrowHeight;     //指箭头尖到底的距离
typedef CGFloat YGArrowOffset;     //箭头中轴的偏移距离。可以为负值。
typedef CGSize  YGArrowSize;
typedef CGFloat YGBubbleRadius;    //气泡边框的圆角

extern YGArrowOffset YGArrowOffsetMid;   //箭头居中放置


@interface YGBubble : NSObject

@property (strong, nonatomic) UIBezierPath *path;

/**
 创建一个气泡路径

 @param bubbleSize 气泡路径范围矩形大小
 @param direction 气泡箭头指向
 @param arrowSize 气泡箭头尺寸
 @param offset 气泡箭头中轴偏移。top bottom从左到右偏移距离为正，left right从上到下偏移为正
 @param radius 气泡的圆角
 @return 路径
 */
+ (YGBubble *)bubble:(CGSize)bubbleSize
           direction:(YGBubbleDirection)direction
           arrowSize:(YGArrowSize)arrowSize
         arrowOffset:(YGArrowOffset)offset
              radius:(YGBubbleRadius)radius;

@end
