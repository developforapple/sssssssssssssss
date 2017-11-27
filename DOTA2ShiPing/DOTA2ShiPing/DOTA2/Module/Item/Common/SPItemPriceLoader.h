//
//  SPItemPriceLoader.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class SPItem;
@class SPMarketItem;

@interface SPItemPriceBase : SPObject
@property (copy, nonatomic) NSString *error;
@end

// Dota2市场价格
@interface SPItemDota2Price : SPItemPriceBase
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *originPrice;

// 未实现
@property (assign, nonatomic) float priceF;
@property (assign, nonatomic) float originPriceF;
@property (copy, nonatomic) NSString *prefix;
@property (copy, nonatomic) NSString *suffix;
@end

// Steam市场价格预览
@interface SPItemSteamPriceOverview : SPItemPriceBase
@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *lowest_price;
@property (assign, nonatomic) NSInteger volume;
@property (copy, nonatomic) NSString *median_price;
@end

// Steam市场价格列表
@interface SPItemSteamPriceList : SPItemPriceBase
@property (assign, nonatomic) BOOL success;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger pagesize;
@property (assign, nonatomic) NSInteger total_count;
@property (copy, nonatomic) NSString *results_html;
@end

// Steam市场价格
@interface SPItemSteamPrice : SPItemPriceBase
@property (strong, nonatomic) NSArray<SPMarketItem *> *items;
@property (strong, nonatomic) SPItemSteamPriceOverview *overview;
@property (strong, nonatomic) SPItemSteamPriceList *list;

- (NSString *)basePrice;

@end

@interface SPItemPriceLoader : SPObject

// 获取Dota2商城价格
+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(void (^)(SPItemDota2Price *price))completion;
// 获取steam市场价格预览
+ (void)loadSteamMarketPriceOverview:(SPItem *)item
                          completion:(void(^)(SPItemSteamPrice *price))completion;
// 获取steam市场价格列表
+ (void)loadSteamMarketPriceList:(SPItem *)item
                          pageNo:(NSInteger)pageNo
                      completion:(void(^)(SPItemSteamPrice *price))completion;
// 获取steam市场价格列表，旧
+ (void)loadSteamMarketPrice:(SPItem *)item
                  completion:(void(^)(SPItemSteamPrice *price))completion;

@end
