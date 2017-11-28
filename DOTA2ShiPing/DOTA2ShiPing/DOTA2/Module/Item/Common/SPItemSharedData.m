//
//  SPItemSharedData.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSharedData.h"
#import "SPDataManager.h"
#import "SPItemQuery.h"
#import "SPGamepediaAPI.h"
#import "SPConfigManager.h"

@interface SPItemSharedData ()
@property (strong, readwrite, nonatomic) SPItem *item;
@property (strong, readwrite, nonatomic) SPHero *hero;
@property (strong, readwrite, nonatomic) SPItemRarity *rarity;
@property (strong, readwrite, nonatomic) SPItemPrefab *prefab;
@property (strong, readwrite, nonatomic) SPItemQuality *quality;
@property (strong, readwrite, nonatomic) SPItemSlot *slot;
@property (strong, readwrite, nonatomic) SPDotaEvent *event;
@property (strong, readwrite, nonatomic) UIColor *color;
@property (strong, readwrite, nonatomic) NSArray<SPItemStyle *> *styles;
@property (strong, readwrite, nonatomic) SPItemSets *itemSet;
@property (strong, readwrite, nonatomic) NSArray<SPItem *> *bundleItems;
@property (strong, readwrite, nonatomic) NSArray<SPItem *> *lootList;

@property (strong, readwrite, nonatomic) SPItemDota2Price *dota2Price;
@property (strong, readwrite, nonatomic) SPItemSteamPrice *steamPrice;

@property (strong, readwrite, nonatomic) SPGamepediaData *extraData;
@property (assign, readwrite, nonatomic) NSTimeInterval loadExtraDataConsumed;

@end

@implementation SPItemSharedData

- (instancetype)initWithItem:(SPItem *)item
{
    self = [super init];
    if (self) {
        self.item = item;
        [self setup];
    }
    return self;
}

- (void)setup
{
    SPHero *hero = [[SPDataManager shared] heroesOfNames:[self.item.heroes componentsSeparatedByString:@"|"]].firstObject;
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:self.item.item_rarity];
    SPItemPrefab *prefab = [[SPDataManager shared] prefabOfName:self.item.prefab];
    SPItemQuality *quality = [[SPDataManager shared] qualityOfName:self.item.item_quality];
    SPDotaEvent *event = [[SPDataManager shared] eventOfId:self.item.event_id];
    UIColor *color = self.item.itemColor;
    
    SPItemSlot *slot;
    if (self.item.item_slot.length) {
        slot = [[SPDataManager shared] slotOfName:self.item.item_slot];
        if (!slot && hero) {
            for (SPItemSlot *aHeroSlot in hero.ItemSlots) {
                if ([aHeroSlot.SlotName isEqualToString:self.item.item_slot]) {
                    slot = aHeroSlot;
                    break;
                }
            }
        }
    }else{
        slot = [[SPDataManager shared] slotOfName:self.item.prefab];
    }
    
    self.hero = hero;
    self.prefab = prefab;
    self.rarity = rarity;
    self.quality = quality;
    self.slot = slot;
    self.color = color;
    self.event = event;
    
    if ([self.item.prefab isEqualToString:@"bundle"]) {
        NSArray *sets = [[SPDataManager shared] querySetsWithCondition:@"store_bundle = ?" values:@[self.item.name?:@""]];
        self.itemSet = sets.firstObject;
    }else if (self.item.bundles.length){
        NSString *bundle = [self.item.bundles componentsSeparatedByString:@"||"].firstObject;
        NSArray *sets = [[SPDataManager shared] querySetsWithCondition:@"store_bundle = ?" values:@[bundle]];
        self.itemSet = sets.firstObject;
    }
    
    NSArray<SPItemStyle *> *styles = [NSArray yy_modelArrayWithClass:[SPItemStyle class] json:self.item.styles];
    NSArray *sortedStyles = [styles sortedArrayUsingComparator:^NSComparisonResult(SPItemStyle *obj1, SPItemStyle *obj2) {
        return [@(obj1.index.intValue) compare:@(obj2.index.intValue)];
    }];
    self.styles = sortedStyles;
    
    [self updateItems];
    
    [self loadPricesAuto];
    [self loadExtraDataAuto];
}

- (void)updateItems
{
    NSString *bundleItems = self.item.bundleItems;
    NSString *bundles = self.item.bundles;
    NSString *lootList = self.item.lootList;
    
    if (bundleItems.length) {
        // 饰品是一个包
        NSArray *itemNames = [bundleItems componentsSeparatedByString:@"||"];
        SPItemQuery *query = [SPItemQuery queryWithItemNames:itemNames];
        [query updateItems];
        self.bundleItems = query.items;
        
    }else if (bundles.length){
        // 饰品属于一个包
        
        NSArray *itemNames = self.itemSet.items;
        SPItemQuery *query = [SPItemQuery queryWithItemNames:itemNames];
        [query updateItems];
        self.bundleItems = query.items;
        
    }else if (lootList.length){
        //包含一个掉落列表
        NSArray *itemNames = [[SPDataManager shared] itemsInLootlist:lootList];
        SPItemQuery *query = [SPItemQuery queryWithItemNames:itemNames];
        [query updateItems];
        self.lootList = query.items;
        
    }else{
        //不包含包内容
        
    }
}

- (void)loadPricesAuto
{
    if (Config.sp_config_item_detail_load_price_auto) {
        [self loadDota2Price:YES];
        [self loadSteamPrice:YES];
    }
}

- (void)loadDota2Price:(BOOL)forced
{
    if (forced || Config.sp_config_item_detail_load_price_auto) {
        [SPItemPriceLoader loadDota2MarketPrice:self.item completion:^(SPItemDota2Price *price) {
            self.dota2Price = price;
        }];
    }
}

- (void)loadSteamPrice:(BOOL)forced
{
    if (forced || Config.sp_config_item_detail_load_price_auto) {
        [SPItemPriceLoader loadSteamMarketPriceOverview:self.item completion:^(SPItemSteamPrice *price) {
            self.steamPrice = price;
        }];
    }
}

- (void)loadExtraDataAuto
{
    if (Config.sp_config_item_detail_load_extra_data_auto) {
        [self loadExtraData:YES];
    }
}

- (void)loadExtraData:(BOOL)forced
{
    if (forced || Config.sp_config_item_detail_load_extra_data_auto) {
        AsyncBenchmarkTestBegin(SPItemSharedDataLoadExtraData);
        [[SPGamepediaAPI shared] fetchItemInfo:self.item completion:^(BOOL suc, SPGamepediaData *data) {
            AsyncBenchmarkTestEnd(SPItemSharedDataLoadExtraData);
            self.loadExtraDataConsumed = __benchmarkResult_SPItemSharedDataLoadExtraData / 1000; //精确到秒
            self.extraData = data;
        }];
    }
}

@end
