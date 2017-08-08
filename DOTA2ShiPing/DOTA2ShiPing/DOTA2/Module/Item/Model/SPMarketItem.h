//
//  SPMarketItem.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPMarketItem : NSObject
@property (strong, nonatomic) NSString *name;   //铭刻 小飞侠
@property (strong, nonatomic) NSString *qty;    //41
@property (strong, nonatomic) NSString *price;  //$0.21 USD
@property (strong, nonatomic) NSString *href;   //

- (NSString *)priceNumber;

@end
