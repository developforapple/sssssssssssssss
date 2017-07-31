//
//  SPItemColor.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemColor.h"
#import "YYModel.h"

extern UIColor *blendColors(UIColor *color1,UIColor *color2,CGFloat alpha){
    alpha = MAX(0, MIN(1, alpha));
    
    if (!color1) return [color2 colorWithAlphaComponent:alpha];
    if (!color2) return color1;
    
    CGFloat r1,g1,b1,r2,g2,b2,r3,g3,b3;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:NULL];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:NULL];

    r3 = r2 * alpha + r1 * (1-alpha);
    g3 = g2 * alpha + g1 * (1-alpha);
    b3 = b2 * alpha + b1 * (1-alpha);
    
    return [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.f];
}

@interface SPItemColor ()
@property (assign, readwrite, nonatomic) float r;
@property (assign, readwrite, nonatomic) float g;
@property (assign, readwrite, nonatomic) float b;
@property (strong, readwrite, nonatomic) UIColor *color;
@end

@implementation SPItemColor

YYModelDefaultCode

- (void)setHex_color:(NSString *)hex_color
{
    _hex_color = hex_color;
    
    char *x = [hex_color hasPrefix:@"#"]?"#%x":"%x";
    const char *p = [hex_color UTF8String];
    int v  = 0;
    sscanf(p, x,&v);
    NSInteger r = (v & 0xFF0000) >> 16;
    NSInteger g = (v & 0xFF00) >> 8;
    NSInteger b = (v & 0xFF);
    
    self.r = r/255.f;
    self.g = g/255.f;
    self.b = b/255.f;
    self.color = [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:1.f];
}

@end

