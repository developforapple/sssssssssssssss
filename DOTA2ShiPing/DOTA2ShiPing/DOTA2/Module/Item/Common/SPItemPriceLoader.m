//
//  SPItemPriceLoader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPriceLoader.h"
#import "SPItem.h"
#import "TFHpple.h"
#import "SPSteamAPI.h"
#import "SPMarketItem.h"

@implementation SPItemPriceBase
+ (instancetype)error:(NSString *)error
{
    SPItemPriceBase *price = [[self class] new];
    price.error = error;
    return price;
}
@end

@implementation SPItemDota2Price
- (instancetype)initWithPrice:(NSString *)price originPrice:(NSString *)originPrice
{
    self = [super init];
    if (self) {
        self.price = price;
        self.originPrice = originPrice;
    }
    return self;
}
@end

@implementation SPItemSteamPriceOverview
@end

@implementation SPItemSteamPrice
- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithOverview:(SPItemSteamPriceOverview *)overview
{
    self = [super init];
    if (self) {
        self.overview = overview;
    }
    return self;
}

- (NSString *)basePrice
{
    if (self.overview) {
        return self.overview.lowest_price;
    }
    return self.items.firstObject.price;
}

@end

@implementation SPItemPriceLoader

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(void (^)(SPItemDota2Price *price))completion
{
    if (!completion) return;
    
    RunOnGlobalQueue(^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://store.dota2.com.cn/itemdetails/%@",item.token]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (!data || data.length == 0) {
            completion([SPItemDota2Price error:@"网络错误"]);
            return;
        }
        
        TFHpple *root = [TFHpple hppleWithHTMLData:data];
        TFHppleElement *box = [root searchWithXPathQuery:@"//div[@class='Price contentBox']"].firstObject;
        
        NSString *price,*originPrice;
        
        for (TFHppleElement *element in box.children) {
            
            if (element.isTextNode) {
                NSString *text = [element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (text.length > 0) {
                    price = text;
                }
            }else if([[element objectForKey:@"class"] isEqualToString:@"OriginalPrice"]){
                originPrice = [element.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
        }
        
        RunOnMainQueue(^{
            if (price.length == 0 && originPrice.length == 0) {
                completion([SPItemDota2Price error:@"未找到该物品"]);
            }else{
                completion([[SPItemDota2Price alloc] initWithPrice:price originPrice:originPrice]);
            }
        });
    });
}

+ (TFHppleElement *)search:(TFHppleElement *)element class:(NSString *)class
{
    NSString *elementClass = [element objectForKey:@"class"];
    if ([elementClass isEqualToString:class]) {
        return element;
    }
    for (TFHppleElement *child in element.children) {
        TFHppleElement *result = [self search:child class:class];
        if (result) {
            return result;
        }
    }
    return nil;
}

+ (void)loadSteamMarketPriceOverview:(SPItem *)item
                          completion:(void(^)(SPItemSteamPrice *price))completion
{
    if (!completion) return;
    
    [[SPSteamAPI shared] fetchSteamPriceOverview:item.market_hash_name completion:^(BOOL suc, id object, NSString *taskDesc) {
        
        if (!suc) {
            completion([SPItemSteamPrice error:object?:@"网络错误"]);
            return;
        }
        
        SPItemSteamPriceOverview *overview = [SPItemSteamPriceOverview yy_modelWithJSON:object];
        if (!overview) {
            completion([SPItemSteamPrice error:@"失败"]);
            return;
        }
        if (!overview.success) {
            completion([SPItemSteamPrice error:@"未找到改物品"]);
            return;
        }
        
        SPItemSteamPrice *price = [[SPItemSteamPrice alloc] initWithOverview:overview];
        completion(price);
    }];
}

+ (void)loadSteamMarketPrice:(SPItem *)item completion:(void(^)(SPItemSteamPrice *price))completion
{
    if (!completion) return;
    
    [[SPSteamAPI shared] fetchSteamMarketContent:item.name completion:^(BOOL suc, TFHpple *object, NSString *taskDesc) {
       
        if (!suc) {
            completion([SPItemSteamPrice error:@"网络错误"]);
            return;
        }
        RunOnGlobalQueue(^{
            NSMutableArray *list = [NSMutableArray array];
            NSArray<TFHppleElement *> *result = [object searchWithXPathQuery:@"//a[@class='market_listing_row_link']"];
            for (TFHppleElement *a in result) {
                NSString *href = [a objectForKey:@"href"];
                
                TFHppleElement *name_element = [self search:a class:@"market_listing_item_name"];
//                TFHppleElement *qty_element = [self search:a class:@"market_listing_num_listings_qty"];
                TFHppleElement *price_element = [self search:a class:@"normal_price"];
                
                NSString *name = [name_element firstTextChild].content;
//                NSString *qty = [qty_element firstTextChild].content;
                NSString *price = [price_element firstTextChild].content;
                
                SPMarketItem *aItem = [SPMarketItem new];
                aItem.name = name;
//                aItem.qty = qty;
                aItem.price = price;
                aItem.href = href;
                [list addObject:aItem];
            }
            RunOnMainQueue(^{
                completion([[SPItemSteamPrice alloc] initWithItems:list]);
            });
        });
    }];
}

@end
