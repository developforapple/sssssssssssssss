//
//  SPMarketItem.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPItemColor.h"

@interface SPMarketItem : NSObject
@property (copy, nonatomic) NSString *name;   //铭刻 小飞侠
@property (copy, nonatomic) NSString *qty;    //41
@property (copy, nonatomic) NSString *price;  //$0.21 USD
@property (copy, nonatomic) NSString *href;   //
@property (copy, nonatomic) NSString *hexColor;
@property (copy, nonatomic) NSString *image;

@property (strong, nonatomic) SPItemColor *color;

- (NSString *)priceNumber;

@end
