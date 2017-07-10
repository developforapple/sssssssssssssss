//
//  YGBubbleView.m
//  CDT
//
//  Created by wwwbbat on 2017/5/27.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "YGBubbleView.h"

@interface YGBubbleView ()
@property (strong, nonatomic) CALayer *bubbleLayer;
@end

@implementation YGBubbleView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.direction = YGBubbleDirectionTop;
        self.arrowSize = CGSizeMake(8, 6);
        self.arrowOffset = YGArrowOffsetMid;
        self.bubbleRadius = 4;
        self.bubbleColor = [UIColor whiteColor];
        self.bubbleStrokeColor = nil;
        self.bubbleStrokeLineWidth = 0.f;
    }
    return self;
}

- (void)setDirectionDesc:(NSString *)directionDesc
{
    _directionDesc = directionDesc;
    NSString *desc = [directionDesc lowercaseString];
    if ([desc isEqualToString:@"top"]) {
        self.direction = YGBubbleDirectionTop;
    }else if ([desc isEqualToString:@"left"]){
        self.direction = YGBubbleDirectionLeft;
    }else if ([desc isEqualToString:@"bottom"]){
        self.direction = YGBubbleDirectionBottom;
    }else if ([desc isEqualToString:@"right"]){
        self.direction = YGBubbleDirectionRight;
    }else{
        self.direction = YGBubbleDirectionTop;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.bubbleLayer) {
        [self.bubbleLayer removeFromSuperlayer];
        self.bubbleLayer = nil;
    }
    
    YGBubble *bubble = [YGBubble bubble:rect.size direction:self.direction arrowSize:self.arrowSize arrowOffset:self.arrowOffset radius:self.bubbleRadius];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bubble.path.CGPath;
    layer.frame = rect;
    layer.lineWidth = self.bubbleStrokeLineWidth;
    layer.strokeColor = self.bubbleStrokeColor.CGColor;
    layer.fillColor = self.bubbleColor.CGColor;
    
    self.bubbleLayer = layer;
    [self.layer insertSublayer:layer atIndex:0];
}

@end
