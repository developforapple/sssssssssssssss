//
//  UIImage+Mask.m
//  CDT
//
//  Created by wwwbbat on 2017/6/28.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "UIImage+Mask.h"

@implementation UIImage (Mask)

+ (UIImage *)holeMaskImage:(CGSize)size
                  holeSize:(CGSize)holeSize
                    radius:(CGFloat)radius
               aroundColor:(UIColor *)aroundColor
                 holeColor:(UIColor *)holeColor
                holeBorder:(CGFloat)borderWidth
           holeBorderColor:(UIColor *)holeBorderColor
{
    CGRect imgRect = CGRectMake(0,
                                0,
                                size.width,
                                size.height);
    CGRect holeRect = CGRectMake((size.width-holeSize.width)/2,
                                 (size.height-holeSize.height)/2,
                                 holeSize.width,
                                 holeSize.height);
    

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imgRect];
    UIBezierPath *holePath = [UIBezierPath bezierPathWithRoundedRect:holeRect cornerRadius:radius];
    [path appendPath:holePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.frame = imgRect;
    imgLayer.backgroundColor = aroundColor.CGColor;
    imgLayer.mask = maskLayer;
    
    
    CALayer *root = [CALayer layer];
    root.bounds = imgRect;
    root.backgroundColor = [UIColor clearColor].CGColor;
    [root addSublayer:imgLayer];
    
    
    CGFloat alpha;
    [holeColor getWhite:NULL alpha:&alpha];
    
    if (borderWidth > 0 || alpha > 0) {
        CGPathRef pathRef = CGPathCreateWithRoundedRect(CGRectMake(0, 0, CGRectGetWidth(holeRect), CGRectGetHeight(holeRect)), radius, radius, nil);
        CAShapeLayer *holeLayer = [CAShapeLayer layer];
        holeLayer.frame = holeRect;
        holeLayer.path = pathRef;
        holeLayer.fillColor = holeColor.CGColor;
        holeLayer.strokeColor = holeBorderColor.CGColor;
        holeLayer.lineWidth = borderWidth;
        
        [root addSublayer:holeLayer];
    
        CGPathRelease(pathRef);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [root renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)holeMaskImage:(CGSize)size
{
    return [self holeMaskImage:size holeSize:size radius:size.width/2 aroundColor:[UIColor whiteColor] holeColor:[UIColor clearColor] holeBorder:0.5 holeBorderColor:RGBColor(224, 224, 224, 1)];
}

@end
