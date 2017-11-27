//
//  SPInventoryFilter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPPlayer.h"
#import "SPPlayerCommon.h"
#import "SPItem.h"

@class SPInventoryFilterCondition;

@interface SPInventoryFilter : SPObject

- (instancetype)initWithPlayer:(SPPlayer *)player;

@property (strong, readonly, nonatomic) SPPlayer *player;

// 分类
@property (assign, readonly, nonatomic) SPInventoryCategory category;

// 条件
@property (strong, readonly, nonatomic) SPInventoryFilterCondition *condition;

// 内容更新了的回调
@property (copy, nonatomic) void (^updateCallback)(void);

// 更新分类。将会清空筛选条件。
- (void)updateWithCategory:(SPInventoryCategory)category;
// 根据条件进行筛选。筛选结果临时存放。条件为空时，将会调用 [self updateWithCategory:self.category]
// 返回筛选结果数量
- (NSInteger)updateWithCondition:(SPInventoryFilterCondition *)condition;

@property (strong, readonly, nonatomic) NSArray *titles;
@property (strong, readonly, nonatomic) NSArray<NSArray<SPPlayerItemDetail *> *> *playerItems;


- (NSInteger)itemCount;
- (NSArray<SPItem *> *)itemAtPageIndex:(NSInteger)index;


// 独立的搜索。和上面的属性无关。
- (NSArray *)itemsWithKeywords:(NSString *)keywords;

@end

#import "SPHero.h"
#import "SPItemRarity.h"
#import "SPItemQuality.h"

@interface SPInventoryFilterCondition : SPObject
@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPItemQuality *quality;
@property (assign, nonatomic) SPConditionOption tradeable;  //默认SPConditionOptionUndefined
@property (assign, nonatomic) SPConditionOption markedable; //默认SPConditionOptionUndefined

- (NSString *)tradeableLocalString;
- (NSString *)marketableLocalString;

@end
