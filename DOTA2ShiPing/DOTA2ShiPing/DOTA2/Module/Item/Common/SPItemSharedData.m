//
//  SPItemSharedData.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSharedData.h"
#import "SPDataManager.h"
#import "SPItemFilter.h"

@interface SPItemSharedData ()
@property (strong, readwrite, nonatomic) SPItem *item;
@property (strong, readwrite, nonatomic) SPHero *hero;
@property (strong, readwrite, nonatomic) SPItemRarity *rarity;
@property (strong, readwrite, nonatomic) SPItemPrefab *prefab;
@property (strong, readwrite, nonatomic) SPItemQuality *quality;
@property (strong, readwrite, nonatomic) SPItemSlot *slot;
@property (strong, readwrite, nonatomic) UIColor *color;
@property (strong, readwrite, nonatomic) NSArray<SPItemStyle *> *styles;
@property (strong, readwrite, nonatomic) SPItemSets *itemSet;
@property (strong, readwrite, nonatomic) NSArray<SPItem *> *bundleItems;
@property (strong, readwrite, nonatomic) NSArray<SPItem *> *lootList;

@property (strong, readwrite, nonatomic) SPItemDota2Price *dota2Price;
@property (strong, readwrite, nonatomic) SPItemSteamPrice *steamPrice;

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
    
    [self loadPrices];
}

- (void)updateItems
{
    NSString *bundleItems = self.item.bundleItems;
    NSString *bundles = self.item.bundles;
    NSString *lootList = self.item.lootList;
    
    if (bundleItems.length) {
        // 饰品是一个包
        NSArray *itemNames = [bundleItems componentsSeparatedByString:@"||"];
        SPItemFilter *filter = [SPItemFilter filterWithItemNames:itemNames];
        [filter updateItems];
        self.bundleItems = filter.items;
        
    }else if (bundles.length){
        // 饰品属于一个包
        
        NSArray *itemNames = self.itemSet.items;
        SPItemFilter *filter = [SPItemFilter filterWithItemNames:itemNames];
        [filter updateItems];
        self.bundleItems = filter.items;
        
    }else if (lootList.length){
        //包含一个掉落列表
        NSArray *itemNames = [[SPDataManager shared] itemsInLootlist:lootList];
        SPItemFilter *filter = [SPItemFilter filterWithItemNames:itemNames];
        [filter updateItems];
        self.lootList = filter.items;
        
    }else{
        //不包含包内容
        
    }
}

- (void)loadPrices
{
    [SPItemPriceLoader loadDota2MarketPrice:self.item completion:^(SPItemDota2Price *price) {
        self.dota2Price = price;
    }];
    
    [SPItemPriceLoader loadSteamMarketPriceOverview:self.item completion:^(SPItemSteamPrice *price) {
        self.steamPrice = price;
    }];
    
//    [SPItemPriceLoader loadSteamMarketPrice:self.item completion:^(SPItemSteamPrice *price) {
//        self.steamPrice = price;
//    }];
    
}

@end
