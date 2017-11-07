//
//  SPItemSharedData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPItem.h"
#import "SPHero.h"
#import "SPItemRarity.h"
#import "SPItemPrefab.h"
#import "SPItemQuality.h"
#import "SPItemSlot.h"
#import "SPItemSets.h"
#import "SPItemStyle.h"

#import "SPItemPriceLoader.h"

@interface SPItemSharedData : NSObject

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

// 如果item是一个bundle，那么这里为bundle对应sets的内容
@property (strong, readonly, nonatomic) SPItemSets *itemSet;

// 异步加载的
@property (strong, readonly, nonatomic) SPItemDota2Price *dota2Price;
@property (strong, readonly, nonatomic) SPItemSteamPrice *steamPrice;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// 初始化很耗时
- (instancetype)initWithItem:(SPItem *)item NS_DESIGNATED_INITIALIZER;

@end
