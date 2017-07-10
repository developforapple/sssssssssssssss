//
//  YGIMBubble.m
//  Golf
//
//  Created by bo wang on 2017/2/4.
//  Copyright © 2017年 云高科技. All rights reserved.
//

#import "YGBubble.h"


YGArrowOffset YGArrowOffsetMid = CGFLOAT_MAX;

@implementation YGBubble

+ (instancetype)bubble:(CGSize)bubbleSize
             direction:(YGBubbleDirection)direction
             arrowSize:(YGArrowSize)arrowSize
           arrowOffset:(YGArrowOffset)offset
                radius:(YGBubbleRadius)radius
{
    if (offset != YGArrowOffsetMid) {
        if (direction == YGBubbleDirectionLeft ||
            direction == YGBubbleDirectionBottom) {
            offset = -offset;
        }
    }
    
    YGBubble *b = [YGBubble new];
    
    CGFloat bw = bubbleSize.width;
    CGFloat bh = bubbleSize.height;
    
    CGFloat aw = arrowSize.width;
    CGFloat ah = arrowSize.height;
    
    CGFloat r = radius;
    
    //左上角
    CGPoint t_l_c = CGPointMake(r, r+ah);
    CGPoint t_l_1 = CGPointMake(0, r+ah);
    __unused CGPoint t_l_2 = CGPointMake(r, 0+ah);
    CGFloat t_l_1_a = M_PI;
    CGFloat t_l_2_a = M_PI_2*3;
    
    //右上角
    CGPoint t_r_c = CGPointMake(bw-r, r+ah);
    CGPoint t_r_1 = CGPointMake(bw-r, 0+ah);
    __unused CGPoint t_r_2 = CGPointMake(bw,   r+ah);
    CGFloat t_r_1_a = M_PI_2*3;
    CGFloat t_r_2_a = M_PI*2;
    
    //右下角
    CGPoint b_r_c = CGPointMake(bw-r, bh-r);
    CGPoint b_r_1 = CGPointMake(bw, bh-r);
    __unused CGPoint b_r_2 = CGPointMake(bw-r, bh);
    CGFloat b_r_1_a = 0;
    CGFloat b_r_2_a = M_PI_2;
    
    //左下角
    CGPoint b_l_c = CGPointMake(r, bh-r);
    CGPoint b_l_1 = CGPointMake(r, bh);
    __unused CGPoint b_l_2 = CGPointMake(0, bh-r);
    CGFloat b_l_1_a = M_PI_2;
    CGFloat b_l_2_a = M_PI;
    
    //箭头
    CGFloat ac;
    if (offset == YGArrowOffsetMid) {
        ac = bw/2;
    }else if(offset >= 0){
        ac = offset;
    }else{
        ac = bw - offset;
    }
    ac = Confine(ac, bw-r-aw/2, r+aw/2);
    
    CGPoint a_f_1   = CGPointMake(ac-aw/2, ah);
    CGPoint a_p     = CGPointMake(ac, 0);
    CGPoint a_f_2   = CGPointMake(ac+aw/2, ah);
    
    //开始创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:t_l_1];
    [path addArcWithCenter:t_l_c radius:r startAngle:t_l_1_a endAngle:t_l_2_a clockwise:YES];
    
    [path addLineToPoint:a_f_1];
    [path addLineToPoint:a_p];
    [path addLineToPoint:a_f_2];
    [path addLineToPoint:t_r_1];
    
    [path addArcWithCenter:t_r_c radius:r startAngle:t_r_1_a endAngle:t_r_2_a clockwise:YES];
    
    [path addLineToPoint:b_r_1];
    [path addArcWithCenter:b_r_c radius:r startAngle:b_r_1_a endAngle:b_r_2_a clockwise:YES];
    
    [path addLineToPoint:b_l_1];
    [path addArcWithCenter:b_l_c radius:r startAngle:b_l_1_a endAngle:b_l_2_a clockwise:YES];
    
    [path addLineToPoint:t_l_1];
    
    [path closePath];
    
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 1;
    
    switch (direction) {
        case YGBubbleDirectionTop:break;
        case YGBubbleDirectionLeft:{
            [path applyTransform:CGAffineTransformMakeRotation(M_PI/2)];
        }   break;
        case YGBubbleDirectionBottom:{
            [path applyTransform:CGAffineTransformMakeRotation(M_PI)];
        }   break;
        case YGBubbleDirectionRight:{
            [path applyTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }   break;
    }
    b.path = path;
    return b;
}

@end
