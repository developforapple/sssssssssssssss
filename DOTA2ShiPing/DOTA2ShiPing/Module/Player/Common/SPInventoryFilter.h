//
//  SPInventoryFilter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlayer.h"
#import "SPPlayerCommon.h"

@class SPInventoryFilterCondition;

@interface SPInventoryFilter : NSObject

- (instancetype)initWithPlayer:(SPPlayer *)player;

@property (strong, readonly, nonatomic) SPPlayer *player;

// 分类
@property (assign, nonatomic) SPInventoryCategory category;

// 条件
@property (strong, nonatomic) SPInventoryFilterCondition *condition;

// 内容更新了的回调
@property (copy, nonatomic) void (^updateCallback)(void);

// 更新分类。将会清空筛选条件
- (void)updateWithCategory:(SPInventoryCategory)category;

@property (strong, readonly, nonatomic) NSArray *titles;
@property (strong, readonly, nonatomic) NSArray<NSArray<SPPlayerItemDetail *> *> *items;

- (NSArray *)itemsWithKeywords:(NSString *)keywords;

@end

#import "SPHero.h"
#import "SPItemRarity.h"
#import "SPItemQuality.h"

@interface SPInventoryFilterCondition : NSObject
@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPItemQuality *quality;
@property (assign, nonatomic) SPConditionOption tradeable;  //默认-1
@property (assign, nonatomic) SPConditionOption markedable; //默认-1
@end
