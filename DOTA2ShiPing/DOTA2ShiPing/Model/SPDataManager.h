//
//  SPDataManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHero.h"
#import "SPItemPrefab.h"
#import "SPItemRarity.h"
#import "SPItemColor.h"
#import "SPItemSets.h"
#import "SPItemQuality.h"

#import "FMDB.h"

@interface SPDataManager : NSObject

+ (instancetype)shared;

@property (strong, nonatomic) NSArray<SPHero *> *heroes;
@property (strong, nonatomic) NSArray<SPHero *> *prefabs;
@property (strong, nonatomic) NSArray<SPItemRarity *> *rarities;
@property (strong, nonatomic) NSArray<SPItemColor *> *colors;
@property (strong, nonatomic) NSArray<SPItemQuality *> *qualities;

- (SPItemRarity *)rarityOfName:(NSString *)name;
- (SPItemColor *)colorOfName:(NSString *)name;
- (SPItemPrefab *)prefabOfName:(NSString *)name;
- (NSArray<SPItemPrefab *> *)prefabsOfNames:(NSArray<NSString *> *)names;
- (NSArray<SPItemPrefab *> *)prefabsOfEntranceType:(SPItemEntranceType)type;

#pragma mark - DB
@property (strong, readonly, nonatomic) FMDatabase *db;
// 查询捆绑包
- (NSArray<SPItemSets *> *)querySetsWithCondition:(NSString *)condition values:(NSArray *)values;

@end
