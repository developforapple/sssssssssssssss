//
//  SPDataManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPLocale.h"
#import "SPHero.h"
#import "SPItemPrefab.h"
#import "SPItemRarity.h"
#import "SPItemColor.h"
#import "SPItemSets.h"
#import "SPItemQuality.h"
#import "SPLootList.h"
#import "SPDotaEvent.h"
#import "SPItem.h"
#import "FMDB.h"

/**
 应用需要使用的数据
 */
@interface SPDataManager : SPObject

+ (instancetype)shared;

- (void)reloadData;

- (SPItemRarity *)rarityOfName:(NSString *)name;
- (SPItemColor *)colorOfName:(NSString *)name;
- (SPItemPrefab *)prefabOfName:(NSString *)name;
- (NSArray<SPItemPrefab *> *)prefabsOfNames:(NSArray<NSString *> *)names;
- (NSArray<SPItemPrefab *> *)prefabsOfEntranceType:(SPItemEntranceType)type;
- (NSArray<SPHero *> *)heroesOfNames:(NSArray<NSString *> *)heroes;
- (SPItemQuality *)qualityOfName:(NSString *)name;
- (SPItemSlot *)slotOfName:(NSString *)name;
- (SPDotaEvent *)eventOfId:(NSString *)eventId;

// 查询捆绑包
- (NSArray<SPItemSets *> *)querySetsWithCondition:(NSString *)condition values:(NSArray *)values;

- (NSArray<NSString *> *)itemsInLootlist:(NSString *)lootlist;

- (NSArray<SPItem *> *)queryItems:(NSString *)condition values:(NSArray *)values;

@end

#ifndef SPLOCAL
    #define SPLOCAL(token,notfound) ([[SPDataManager shared] localizedString:( token )] ?: ( notfound ))
#endif

#ifndef SPLOCALNONIL
    #define SPLOCALNONIL(token) SPLOCAL( ( token ),( token ) )
#endif

@interface SPDataManager (Local)
@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *localMap;
// 忽略大小写和#前缀，返回本地化后的字符串。没找到时返回nil
- (NSString *)localizedString:(NSString *)token;
@end


@interface SPDataManager (BaseData)
@property (strong, readonly, nonatomic) NSArray<SPHero *> *heroes;
@property (strong, readonly, nonatomic) NSArray<SPItemPrefab *> *prefabs;
@property (strong, readonly, nonatomic) NSArray<SPItemRarity *> *rarities;
@property (strong, readonly, nonatomic) NSArray<SPItemColor *> *colors;
@property (strong, readonly, nonatomic) NSArray<SPItemQuality *> *qualities;
@property (strong, readonly, nonatomic) NSArray<SPItemSlot *> *slots;
@property (strong, readonly, nonatomic) NSArray<SPLootList *> *lootlist;
@property (strong, readonly, nonatomic) NSArray<SPDotaEvent *> *events;
@end

#ifndef SPDB
    #define SPDB [[SPDataManager shared] db]
#endif

#ifndef SPDBOPEN
    #define SPDBOPEN [SPDB open];
#endif

#ifndef SPDBWITHOPEN
    #define SPDBWITHOPEN SPDBOPEN;FMDatabase *db = SPDB;
#endif

#ifndef SPDBCLOSE
    #define SPDBCLOSE [SPDB close];
#endif

@interface SPDataManager (DB)
// 数据库由外部负责打开和关闭
@property (strong, readonly, nonatomic) FMDatabase *db;
@end
