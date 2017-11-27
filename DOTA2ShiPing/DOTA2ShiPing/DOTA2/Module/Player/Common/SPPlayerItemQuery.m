//
//  SPPlayerItemQuery.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemQuery.h"
#import "SPDataManager.h"

@import FMDB;

@interface SPPlayerItemQuery ()

// 默认是全部库存物品
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *filteredPlayerItems;

@end

@implementation SPPlayerItemQuery

+ (instancetype)queryWithPlayerItems:(SPPlayerItemSharedData *)data
{
    SPPlayerItemQuery *query = [[self alloc] init];
    query.playerItemData = data;
    query.filteredPlayerItems = data.inventory.items;
    return query;
}

- (NSArray<SPItem *> *)loadPage:(NSInteger)page
{
    static NSInteger perPage = 100;
    
    NSInteger total = self.filteredPlayerItems.count;
    NSInteger loc = page * perPage;
    if (loc >= total) return nil;
    NSInteger len = (loc + perPage) > total ? (total - loc) : perPage ;
    
    NSArray<SPPlayerItemDetail *> *pagePlayerItems = [self.filteredPlayerItems subarrayWithRange:NSMakeRange(loc, len)];
    NSArray<NSNumber *> *tokens = [pagePlayerItems valueForKeyPath:@"defindex"];
    NSArray<SPItem *> *items = [self queryItems:tokens];
    self.pageNo = page;
    return items;
}

- (NSArray<SPItem *> *)queryItems:(NSArray<NSNumber *> *)tokens
{
    SPDBWITHOPEN
    
    AsyncBenchmarkTestBegin(SPPlayerItemQuery);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *token in tokens) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM items WHERE token = %@;",token];
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSDictionary *dict = resultSet.resultDictionary;
            SPItem *item = [SPItem yy_modelWithDictionary:dict];
            if (item) {
                [result addObject:item];
            }
        }
        [resultSet close];
    }
    
    AsyncBenchmarkTestEnd(SPPlayerItemQuery);
    
    SPDBCLOSE
    
    return result;
}

- (void)filter:(NSArray<SPPlayerItemFilterUnit *> *)units
{
    self.units = units;
    if (units.count > 0) {
        self.filteredPlayerItems = [self excuteFilter];
    }else{
        self.filteredPlayerItems = self.playerItemData.inventory.items;
    }
    self.pageNo = 0;
}

- (NSArray<SPPlayerItemDetail *> *)excuteFilter
{
    NSArray *origin = self.playerItemData.inventory.items;
    NSArray *units1 = [self filterWithKeywords:origin];
    NSArray *units2 = [self filterWithQuality:units1];
    NSArray *units3 = [self filterWithRarity:units2];
    NSArray *units4 = [self filterWithPrefab:units3];
    NSArray *units5 = [self filterWithSlot:units4];
    NSArray *units6 = [self filterWithTradable:units5];
    NSArray *units7 = [self filterWithMarketable:units6];
    NSArray *units8 = [self filterWithHero:units7];
    return units8;
}

- (NSArray<SPPlayerItemDetail *> *)filterWithKeywords:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSString *keywords;
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeInput) {
            keywords = unit.object;
            break;
        }
    }
    if (keywords.length == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return
        [obj.name containsString:keywords] ||
        [obj.market_name containsString:keywords] ||
        [obj.market_hash_name containsString:keywords];
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithQuality:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSMutableArray<NSString *> *condition = [NSMutableArray array];
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeQuality) {
            [condition addObject:unit.object];
        }
    }
    
    if (condition.count == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return
        obj.qualityTag.internal_name && [condition containsObject:obj.qualityTag.internal_name];
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithRarity:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSMutableArray<NSString *> *condition = [NSMutableArray array];
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeRarity) {
            [condition addObject:unit.object];
        }
    }
    
    if (condition.count == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return
        obj.rarityTag.internal_name && [condition containsObject:obj.rarityTag.internal_name];
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithSlot:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSMutableArray<NSString *> *condition = [NSMutableArray array];
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeSlot) {
            [condition addObject:unit.object];
        }
    }
    
    if (condition.count == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return
        obj.slotTag.internal_name && [condition containsObject:obj.slotTag.internal_name];
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithPrefab:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSMutableArray<NSString *> *condition = [NSMutableArray array];
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypePrefab) {
            [condition addObject:unit.object];
        }
    }
    
    if (condition.count == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return
        obj.typeTag.internal_name && [condition containsObject:obj.typeTag.internal_name];
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithTradable:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    BOOL checkYES = NO;
    BOOL checkNO = NO;
    
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeTradable) {
            if ([unit.object isEqualToString:kSPFilterObjectTradableYES]) {
                checkYES = YES;
            }else if ([unit.object isEqualToString:kSPFilterObjectTradableNO]){
                checkNO = YES;
            }
        }
    }
    
    if ( !(checkYES || checkNO)) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        BOOL boolv = obj.tradable.boolValue;
        return ( checkYES ? boolv : YES ) && ( checkNO ? !boolv : YES );
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithMarketable:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    BOOL checkYES = NO;
    BOOL checkNO = NO;
    
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeMarketable) {
            if ([unit.object isEqualToString:kSPFilterObjectMarketableYES]) {
                checkYES = YES;
            }else if ([unit.object isEqualToString:kSPFilterObjectMarketableNO]){
                checkNO = YES;
            }
        }
    }
    
    if ( !(checkYES || checkNO)) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail * obj, NSUInteger idx, BOOL *stop) {
        BOOL boolv = obj.marketable.boolValue;
        return ( checkYES ? boolv : YES ) && ( checkNO ? !boolv : YES );
    }];
    return [input objectsAtIndexes:indexes];
}

- (NSArray<SPPlayerItemDetail *> *)filterWithHero:(NSArray<SPPlayerItemDetail *> *)input
{
    if (input.count == 0) return input;
    
    NSMutableArray<NSString *> *condition = [NSMutableArray array];
    for (SPPlayerItemFilterUnit *unit in self.units) {
        if ([unit type] == SPPlayerItemFilterTypeHero) {
            [condition addObject:[(SPHero *)unit.object name]];
        }
    }
    
    if (condition.count == 0) return input;
    
    NSIndexSet *indexes = [input indexesOfObjectsPassingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return                                                                                  
        obj.heroTag.internal_name && [condition containsObject:obj.heroTag.internal_name];
    }];
    return [input objectsAtIndexes:indexes];
}

@end
