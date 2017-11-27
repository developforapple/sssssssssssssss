//
//  SPItemColor.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class UIColor;

@interface SPItemColor : SPObject

// desc_legendary
@property (strong, nonatomic) NSString *name;
// ItemRarityLegendary
@property (strong, nonatomic) NSString *color_name;
// #d32ce6
@property (strong, nonatomic) NSString *hex_color;

@property (assign, readonly, nonatomic) float r;
@property (assign, readonly, nonatomic) float g;
@property (assign, readonly, nonatomic) float b;
@property (strong, readonly, nonatomic) UIColor *color;

@end

extern UIColor *blendColors(UIColor *color1,UIColor *color2,CGFloat alpha);
