//
//  SPItemColor.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface SPItemColor : NSObject

// key
@property (strong, nonatomic) NSString *token;      //desc_uncommon

// data
@property (strong, nonatomic) NSString *color_name; //ItemRarityUncommon
@property (strong, nonatomic) NSString *hex_color;  //#5e98d9

@property (assign, nonatomic) float r;
@property (assign, nonatomic) float g;
@property (assign, nonatomic) float b;

- (UIColor *)color;

// 手动计算设定透明度后的混合颜色。alpha，混合的透明度。baseColor底色，默认为白色。
- (UIColor *)blendColorWithAlpha:(float)alpha baseColor:(UIColor *)baseColor;

@end
