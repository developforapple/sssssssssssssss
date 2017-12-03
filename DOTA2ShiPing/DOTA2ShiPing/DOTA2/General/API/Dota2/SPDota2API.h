//
//  SPDota2API.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPDota2MarketItem.h"

@interface SPDota2API : SPObject

+ (void)fetchDota2SpecilPriceItem:(void (^)(SPDota2SpotlightItem *item))completion;

@end
