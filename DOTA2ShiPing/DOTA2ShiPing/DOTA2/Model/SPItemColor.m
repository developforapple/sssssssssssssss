//
//  SPItemColor.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemColor.h"
#import <YYModel.h>

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
}

- (UIColor *)color
{
    return [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:1.f];
}

- (UIColor *)blendColorWithAlpha:(float)alpha baseColor:(UIColor *)baseColor
{
    static CGFloat (^algorithm)(CGFloat,CGFloat,CGFloat) = ^CGFloat(CGFloat c1,CGFloat c2,CGFloat a1){
        return c1*a1+c2*(1-a1);
    };
    
    CGFloat r2,g2,b2;
    
    if (!baseColor) {
        r2 = g2 = b2 = 1.f;
    }else{
        [baseColor getRed:&r2 green:&g2 blue:&b2 alpha:NULL];
    }
    CGFloat r = algorithm(self.r,r2,alpha);
    CGFloat g = algorithm(self.g,g2,alpha);
    CGFloat b = algorithm(self.b,b2,alpha);
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

@end

//204 = 255*0.1+x*0.9     198
//75  = 255*0.1+x*0.9     55
//56  = 255*0.1+x*0.9     39

//253 =   252
//103     86
//78      58

