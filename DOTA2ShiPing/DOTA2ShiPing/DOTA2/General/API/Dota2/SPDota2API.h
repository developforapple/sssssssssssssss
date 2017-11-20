//
//  SPDota2API.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPDota2MarketItem.h"

@interface SPDota2API : NSObject

+ (void)fetchDota2SpecilPriceItem:(void (^)(SPDota2MarketItem *item))completion;

@end
