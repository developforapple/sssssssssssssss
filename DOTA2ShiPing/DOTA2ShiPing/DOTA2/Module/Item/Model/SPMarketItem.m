//
//  SPMarketItem.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPMarketItem.h"

@interface SPMarketItem ()
{
    
}
@end

@implementation SPMarketItem

- (NSString *)priceNumber
{
    NSString *p = [[self.price componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@".0123456789"] invertedSet]] componentsJoinedByString:@""];
    return p;
}

- (SPItemColor *)color
{
    if (!_color){
        _color = [SPItemColor new];
        [_color setHex_color:self.hexColor];
    }
    return _color;
}

@end
