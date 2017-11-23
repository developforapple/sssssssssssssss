//
//  SPItemQuery.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHero.h"
#import "SPItemRarity.h"
#import "SPItem.h"
#import "SPItemPrefab.h"
#import "SPItemSets.h"
#import "SPDotaEvent.h"
#import "SPFilterOption.h"

// 过滤器
@interface SPItemQuery : NSObject

// 根据英雄筛选
+ (instancetype)queryWithHero:(SPHero *)hero;

// 根据多个类型进行筛选
+ (instancetype)queryWithPerfabs:(NSArray<SPItemPrefab *> *)prefabs;

// 根据事件筛选
+ (instancetype)queryWithEvent:(SPDotaEvent *)event;

// 根据关键词筛选
+ (instancetype)queryWithKeywords:(NSString *)keywords;

// 根据包中饰品列表筛选
+ (instancetype)queryWithItemNames:(NSArray<NSString *> *)itemNames;

// 外部导入的物品
+ (instancetype)importItems:(NSArray<SPItem *> *)items;

// 根据有序的tokens查找
+ (instancetype)queryWithOrderedTokens:(NSArray<NSNumber *> *)tokens;

@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) NSArray<SPItemPrefab *> *prefabs;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPDotaEvent *event;
@property (strong, nonatomic) NSString *keywords;
@property (strong, nonatomic) NSArray *itemNames;
@property (strong, nonatomic) NSArray<NSNumber *> *orderedTokens;
@property (strong, nonatomic) NSString *queryTitle;

// 查询到的数据
@property (strong, nonatomic) NSArray<SPItem *> *items;

- (BOOL)updateItems;
- (void)asyncUpdateItems:(void (^)(BOOL suc,NSArray *items))completion;


// 完整的饰品分组
@property (strong, nonatomic) NSArray<NSArray<SPItem *> *> *fullItems;
@property (strong, nonatomic) NSArray<NSString *> *fullTitles;

// 过滤后的饰品分组
@property (strong, nonatomic) NSArray<NSArray<SPItem *> *> *filteredItems;
@property (strong, nonatomic) NSArray<NSString *> *filteredTitles;

#pragma mark - Filter
@property (strong, nonatomic) NSArray<SPFilterOption *> *options;
- (void)filter:(NSArray<SPFilterOption *> *)options;

#pragma mark - Display

// 当前显示的饰品分组，根据options来决定
- (NSArray<NSArray<SPItem *> *> *)displayItems;
- (NSArray<NSString *> *)displayTitles;

@end
