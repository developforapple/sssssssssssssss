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

@interface SPItemSharedData : NSObject

@property (strong, readonly, nonatomic) SPItem *item;
@property (strong, readonly, nonatomic) SPHero *hero;
@property (strong, readonly, nonatomic) SPItemRarity *rarity;
@property (strong, readonly, nonatomic) SPItemPrefab *prefab;
@property (strong, readonly, nonatomic) SPItemQuality *quality;
@property (strong, readonly, nonatomic) SPItemSlot *slot;
@property (strong, readonly, nonatomic) UIColor *color;

// 如果item是一个bundle，那么这里为bundle对应sets的内容
@property (strong, readonly, nonatomic) SPItemSets *itemSet;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithItem:(SPItem *)item NS_DESIGNATED_INITIALIZER;

@end
