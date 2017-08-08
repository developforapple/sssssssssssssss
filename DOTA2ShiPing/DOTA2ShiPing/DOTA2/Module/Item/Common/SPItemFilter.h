//
//  SPItemFilter.h
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

// 过滤器
@interface SPItemFilter : NSObject

// 根据英雄筛选
+ (instancetype)filterWithHero:(SPHero *)hero;

// 根据多个类型进行筛选
+ (instancetype)filterWithPerfabs:(NSArray<SPItemPrefab *> *)prefabs;

// 根据关键词筛选
+ (instancetype)filterWithKeywords:(NSString *)keywords;

// 根据包中饰品列表筛选
+ (instancetype)filterWithItemNames:(NSArray<NSString *> *)itemNames;

@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) NSArray<SPItemPrefab *> *prefabs;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) NSString *keywords;
@property (strong, nonatomic) NSArray *itemNames;
@property (strong, nonatomic) NSString *filterTitle;

// 查询到的数据
@property (strong, nonatomic) NSArray<SPItem *> *items;

- (BOOL)updateItems;
- (void)asyncUpdateItems:(void (^)(BOOL suc,NSArray *items))completion;


#pragma mark - Display
// 已经根据segment区分了的饰品
@property (strong, nonatomic) NSArray<NSArray<SPItem *> *> *separatedItems;

// segment的标题。
@property (strong, nonatomic) NSArray<NSString *> *titles;

@end
