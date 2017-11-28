//
//  SPItemSharedData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPItem.h"
#import "SPHero.h"
#import "SPItemRarity.h"
#import "SPItemPrefab.h"
#import "SPItemQuality.h"
#import "SPItemSlot.h"
#import "SPItemSets.h"
#import "SPItemStyle.h"
#import "SPItemPriceLoader.h"
#import "SPGamepediaData.h"
#import "SPDotaEvent.h"
#import "SPPlayerItems.h"

@interface SPItemSharedData : SPObject

@property (strong, nonatomic) SPPlayerItemDetail *playerItem;

@property (strong, readonly, nonatomic) SPItem *item;
@property (strong, readonly, nonatomic) SPHero *hero;
@property (strong, readonly, nonatomic) SPItemRarity *rarity;
@property (strong, readonly, nonatomic) SPItemPrefab *prefab;
@property (strong, readonly, nonatomic) SPItemQuality *quality;
@property (strong, readonly, nonatomic) SPItemSlot *slot;
@property (strong, readonly, nonatomic) UIColor *color;
@property (strong, readonly, nonatomic) NSArray<SPItemStyle *> *styles;

// 包里的所有饰品，或所属包的所有饰品
@property (strong, readonly, nonatomic) NSArray<SPItem *> *bundleItems;
// 珍藏的掉落列表
@property (strong, readonly, nonatomic) NSArray<SPItem *> *lootList;

// 所属的事件
@property (strong, readonly, nonatomic) SPDotaEvent *event;

// 如果item是一个bundle，那么这里为bundle对应sets的内容
@property (strong, readonly, nonatomic) SPItemSets *itemSet;

// 异步加载的
@property (strong, readonly, nonatomic) SPItemDota2Price *dota2Price;
@property (strong, readonly, nonatomic) SPItemSteamPrice *steamPrice;

// 来自 Gamepedia 的数据 异步加载
@property (strong, readonly, nonatomic) SPGamepediaData *extraData;
@property (assign, readonly, nonatomic) NSTimeInterval loadExtraDataConsumed;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// 初始化很耗时
- (instancetype)initWithItem:(SPItem *)item NS_DESIGNATED_INITIALIZER;


- (void)loadPricesAuto;
- (void)loadDota2Price:(BOOL)forced;
- (void)loadSteamPrice:(BOOL)forced;
- (void)loadExtraData:(BOOL)forced;

@end
