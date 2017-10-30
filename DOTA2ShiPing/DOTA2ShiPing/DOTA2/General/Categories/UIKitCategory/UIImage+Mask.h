//
//  UIImage+Mask.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/28.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mask)



/**
 创建中间包含一个洞的图片

 @param size 图片尺寸
 @param holeSize 洞尺寸
 @param radius 洞圆角
 @param aroundColor 图片颜色
 @param holeColor 洞颜色
 @param borderWidth 洞边框
 @param holeBorderColor 洞边框颜色
 @return UIImage
 */
+ (UIImage *)holeMaskImage:(CGSize)size
                  holeSize:(CGSize)holeSize
                    radius:(CGFloat)radius
               aroundColor:(UIColor *)aroundColor
                 holeColor:(UIColor *)holeColor
                holeBorder:(CGFloat)borderWidth
           holeBorderColor:(UIColor *)holeBorderColor;

/**
 创建中间包含一个洞的图片，其中洞大小和图片一致，洞为圆形。洞内透明，无边框。图片白色。

 @param size 图片尺寸
 @return UIImage
 */
+ (UIImage *)holeMaskImage:(CGSize)size;















@end
