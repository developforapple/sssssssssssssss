//
//  SPItemPriceLoader.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPItem;
@class SPMarketItem;

@interface SPItemPriceBase : NSObject
@property (copy, nonatomic) NSString *error;
@end

@interface SPItemDota2Price : SPItemPriceBase
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *originPrice;

// 未实现
@property (assign, nonatomic) float priceF;
@property (assign, nonatomic) float originPriceF;
@property (copy, nonatomic) NSString *prefix;
@property (copy, nonatomic) NSString *suffix;
@end

@interface SPItemSteamPrice : SPItemPriceBase
@property (strong, nonatomic) NSArray<SPMarketItem *> *items;

- (NSString *)basePrice;

@end

@interface SPItemPriceLoader : NSObject

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(void (^)(SPItemDota2Price *price))completion;
+ (void)loadSteamMarketPrice:(SPItem *)item
                  completion:(void(^)(SPItemSteamPrice *price))completion;

@end
