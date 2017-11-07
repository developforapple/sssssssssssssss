//
//  SPItemPriceLoader.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPItem;

typedef void (^SPItemPriceLoaderCompletion)(float price);

@interface SPItemDota2Price : NSObject
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *originPrice;
@property (copy, nonatomic) NSString *error;

// 未实现
@property (assign, nonatomic) float priceF;
@property (assign, nonatomic) float originPriceF;
@property (copy, nonatomic) NSString *prefix;
@property (copy, nonatomic) NSString *suffix;
@end

@interface SPItemSteamPrice : NSObject

@end

@interface SPItemPriceLoader : NSObject

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(void (^)(SPItemDota2Price *price))completion;

@end
