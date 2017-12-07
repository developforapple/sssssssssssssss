//
//  SPItemQuery.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemQuery.h"
#import <Bugly/Bugly.h>
#import "FMDB.h"
#import "SPDataManager.h"

@interface SPItemQuery ()
@property (assign, nonatomic) BOOL importItemsFlag;
@property (assign, nonatomic) BOOL orderedTokensFlag;
@end

@implementation SPItemQuery

+ (instancetype)queryWithHero:(SPHero *)hero
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.hero = hero;
    query.queryTitle = hero.name_loc;
    return query;
}

+ (instancetype)queryWithPerfabs:(NSArray<SPItemPrefab *> *)prefabs
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.prefabs = prefabs;
    return query;
}

+ (instancetype)queryWithEvent:(SPDotaEvent *)event
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.event = event;
    query.queryTitle = event.name_loc;
    return query;
}

+ (instancetype)queryWithKeywords:(NSString *)keywords
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.keywords = keywords;
    query.queryTitle = keywords;
    return query;
}

+ (instancetype)queryWithItemNames:(NSArray<NSString *> *)itemNames
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.itemNames = itemNames;
    return query;
}

+ (instancetype)importItems:(NSArray<SPItem *> *)items
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.items = items;
    query.importItemsFlag = YES;
    return query;
}

+ (instancetype)queryWithOrderedTokens:(NSArray<NSString *> *)tokens
{
    SPItemQuery *query = [[[self class] alloc] init];
    query.orderedTokens = tokens;
    query.orderedTokensFlag = YES;
    return query;
}

- (BOOL)updateItems
{
    if (_importItemsFlag) return YES;
    
    if (_orderedTokensFlag) {
        return [self updateOrderedTokensItems];
    }
    
    SPDBWITHOPEN
    
    NSMutableArray *query = [NSMutableArray array];
    NSMutableArray *params = [NSMutableArray array];
    
    if (self.hero) {
        [query addObject:@" ( heroes LIKE ? ) "];
        [params addObject:[NSString stringWithFormat:@"%%%@%%",self.hero.name]];
    }
    if (self.prefabs) {
        NSMutableArray *prefabQuery = [NSMutableArray array];
        for (SPItemPrefab *prefab in self.prefabs) {
            [prefabQuery addObject:@" ( prefab = ? ) "];
            [params addObject:prefab.name];
        }
        [query addObject:[NSString stringWithFormat:@" (%@) ",[prefabQuery componentsJoinedByString:@" OR "]]];
    }
    if (self.keywords) {
        [query addObject:@" ( name LIKE ? ) "];
        [params addObject:[NSString stringWithFormat:@"%%%@%%",self.keywords]];
    }
    
    if (self.rarity) {
        [query addObject:@" ( rarity = ? ) "];
        [params addObject:self.rarity.name];
    }
    
    if (self.itemNames && self.itemNames.count) {
        NSMutableArray *itemNamesQuery = [NSMutableArray array];
        for (NSString *aItemName in self.itemNames) {
            [itemNamesQuery addObject:@" ( name = ? COLLATE NOCASE ) "];
            [params addObject:aItemName];
        }
        [query addObject:[NSString stringWithFormat:@" (%@) ",[itemNamesQuery componentsJoinedByString:@" OR "]]];
    }
    if (self.event) {
        [query addObject:@" ( event_id = ? )"];
        [params addObject:self.event.event_id];
    }
    
    if (query.count == 0) return NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM items WHERE %@ ORDER BY creation_date DESC",[query componentsJoinedByString:@" AND "]];
    __block BOOL suc = YES;
    
    YYBenchmark(^{
        NSError *error;
        FMResultSet *result;
        result = [db executeQuery:sql values:params error:&error];
        if (error) {
            [result close];
            SPDBCLOSE
            SPLog(@"%@",error);
            suc = NO;
            return ;
        }
        NSMutableArray *items = [NSMutableArray array];
        
        @try{
            while ([result nextWithError:&error]) {
                NSDictionary *dict = result.resultDictionary;
                SPItem *item = [SPItem yy_modelWithDictionary:dict];
                if (item) {
                    [items addObject:item];
                }
            }
        }@catch(NSException *e){
            
            [Bugly reportException:e];
        }
        if (error) {
            [result close];
            SPDBCLOSE
            SPLog(@"%@",error);
            suc = NO;
            return;
        }
        
        self.items = items;
        SPDBCLOSE
        
    }, ^(double ms) {
        SPLog(@"\n\n\tsql:%@ \n\n\t耗时：%.3f ms\n\n ",sql,ms);
    });
    
    return suc;
}

- (BOOL)updateOrderedTokensItems
{
    SPDBWITHOPEN
    
    AsyncBenchmarkTestBegin(SPItemQuery);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *token in self.orderedTokens) {
        
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
    
    AsyncBenchmarkTestEnd(SPItemQuery);
    
    SPDBCLOSE
    
    self.items = result;
    self.fullItems = @[result];
    self.fullTitles = @[@""];
    return YES;
}

- (void)asyncUpdateItems:(void (^)(BOOL suc,NSArray *items))completion
{
    RunOnGlobalQueue(^{
        BOOL suc = [self updateItems];
        if (suc) {
            [self separateItem];
        }
        if (completion) {
            RunOnMainQueue(^{
               completion(suc,self.items);
            });
        }
    });
}

- (void)separateItem
{
    if (_importItemsFlag) {
        [self spearateItemForImportItems];
        return;
    }
    
    if (_orderedTokensFlag) {
        return;
    }
    
    //根据英雄查询饰品，按照部位分类
    //根据其他查询饰品，按照饰品类型分类
    
    if (self.hero) {
        [self spearateItemForHero];
        return;
    }
    
    NSArray *prefabs;
    if (self.prefabs) {
        prefabs = self.prefabs;
    }else{
        NSMutableSet *prefabSet = [NSMutableSet set];
        for (SPItem *item in self.items) {
            NSString *prefabName = item.prefab;
            if (prefabName) {
                [prefabSet addObject:prefabName];
            }
        }
        prefabs = [[SPDataManager shared] prefabsOfNames:[prefabSet allObjects]];
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *prefabNames = [NSMutableArray array];
    
    for (SPItemPrefab *prefab in prefabs) {
        [prefabNames addObject:prefab.name];
        [titles addObject:prefab.name_loc];
        [temp addObject:[NSMutableArray array]];
    }
    
    // 存放未找到合适位置的饰品
    NSMutableArray *others = [NSMutableArray array];
    
    for (SPItem *item in self.items) {
        NSString *prefabName = item.prefab;
        
        if (!prefabName) {
            [others addObject:item];
            continue;
        }
        
        NSUInteger index = [prefabNames indexOfObject:prefabName];
        if (index == NSNotFound) {
            [others addObject:item];
            continue;
        }
        
        NSMutableArray *prefabItems = temp[index];
        [prefabItems addObject:item];
    }
    
    NSMutableArray *segmentTitles = [NSMutableArray array];
    for (NSUInteger index=0;index<temp.count;index++) {
        NSArray *items = temp[index];
        NSString *title = titles[index];
        NSUInteger count = items.count;
        [segmentTitles addObject:title];
//        if (count != 0) {
//            [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",title,(unsigned long)count]];
//        }else{
//            [segmentTitles addObject:title];
//        }
    }
    
    if (others.count != 0) {
        [temp addObject:others];
        [segmentTitles addObject:SPLOCALNONIL(@"dota_othertype")];
//        [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",SPLOCALNONIL(@"dota_othertype"),(unsigned long)others.count]];
    }
    
    self.fullItems = temp;
    self.fullTitles = segmentTitles;
    [self filter:nil];
}

- (void)spearateItemForImportItems
{
    self.fullItems = @[self.items];
    self.fullTitles = @[@"全部物品"];
    [self filter:self.filterUnits];
}

- (void)spearateItemForHero
{
    NSMutableArray *bundles = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    NSMutableArray *slotItems = [NSMutableArray array];
    NSMutableArray *slotNames = [NSMutableArray array];
    NSMutableArray *slotNamesLoc = [NSMutableArray array];
    
    for (SPItemSlot *slot in self.hero.ItemSlots) {
        [slotNames addObject:slot.SlotName];
        [slotNamesLoc addObject:slot.name_loc?:slot.SlotName];
        [slotItems addObject:[NSMutableArray array]];
    }
    
    for (SPItem *item in self.items) {
        if ([item isBundle]) {
            [bundles addObject:item];
        }else if([item isWearable]){
            NSString *itemslot = item.item_slot.length==0?@"weapon":item.item_slot;
            NSUInteger index = [slotNames indexOfObject:itemslot];
            if (index != NSNotFound) {
                [slotItems[index] addObject:item];
            }else{
                [others addObject:item];
                SPLog(@"找到一个未知 itemSlot ： %@",itemslot);
            }
        }else if([item isTaunt]){
            NSInteger index = [slotNames indexOfObject:@"taunt"];
            if (index != NSNotFound) {
                [slotItems[index] addObject:item];
            }else{
                [others addObject:item];
                SPLog(@"饰品为嘲讽，但是英雄没有嘲讽槽位。需要解决这个问题！");
            }
            
        }else{
            [others addObject:item];
        }
    }
    
    NSMutableArray *segmentTitles = [NSMutableArray array];
    NSMutableArray *items = [NSMutableArray array];
    
    if (bundles.count > 0) {
        [segmentTitles addObject:SPLOCALNONIL(@"bundle")];
//        [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",SPLOCALNONIL(@"bundle"),(unsigned long)bundles.count]];
        [items addObject:bundles];
    }
    
    for (NSInteger i=0; i<slotItems.count; i++) {
        NSInteger count = [slotItems[i] count];
        NSString *slotLoc = slotNamesLoc[i];
        [segmentTitles addObject:slotLoc];
        
//        if (count != 0) {
//            [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",slotLoc,(unsigned long)count]];
//        }else{
//            [segmentTitles addObject:slotLoc];
//        }
        [items addObject:slotItems[i]];
    }
    
    
    if (others.count > 0) {
        [segmentTitles addObject:SPLOCALNONIL(@"dota_othertype")];
//        [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",SPLOCALNONIL(@"dota_othertype"),(unsigned long)others.count]];
        [items addObject:others];
    }
    
    self.fullItems = items;
    self.fullTitles = segmentTitles;
    
    [self filter:nil];
}

#pragma mark - Filter

- (BOOL)needFilter
{
    return self.filterUnits && self.filterUnits.count > 0;
}

- (void)filter:(NSArray<SPItemFilterUnit *> *)units
{
    self.filterUnits = units;
    
    if (![self needFilter]) {
        self.filteredItems = nil;
        self.filteredTitles = nil;
        return;
    }
    
    NSString *keywords;
    NSMutableArray *heroes = [NSMutableArray array];
    NSMutableArray *rarities = [NSMutableArray array];
    NSMutableArray *events = [NSMutableArray array];
    
    for (SPItemFilterUnit *unit in self.filterUnits) {
        switch ([unit type]) {
            case SPItemFilterTypeInput:    keywords    = unit.object; break;
            case SPItemFilterTypeHero:     {
                [heroes addObject:unit.object];
            }   break;
            case SPItemFilterTypeRarity:   {
                [rarities addObject:unit.object];
            }   break;
            case SPItemFilterTypeEvent:    {
                [events addObject:unit.object];
            }   break;
        }
    }
    
    NSMutableArray<NSArray *> *newItems = [NSMutableArray array];
    for (NSArray<SPItem *> *itemArray in self.fullItems) {
        NSMutableArray *newItemArray = [NSMutableArray array];
        [newItems addObject:newItemArray];
        for (SPItem *aItem in itemArray) {
            
            // keywords
            BOOL keywordsOK = !keywords.length || [aItem.item_name containsString:keywords] || [aItem.nameWithQualtity containsString:keywords];
            if ( !keywordsOK ) continue;
            
            // hero
            BOOL heroOK = !heroes.count;
            for (SPHero *hero in heroes) {
                if ([aItem.heroes containsString:hero.name]) {
                    heroOK = YES;
                    break;
                }
            }
            if ( ! heroOK ) continue;
            
            // rarity
            BOOL rarityOK = !rarities.count;
            for (SPItemRarity *rarity in rarities) {
                if ([aItem.item_rarity isEqualToString:rarity.name]) {
                    rarityOK = YES;
                    break;
                }
            }
            if ( !rarityOK ) continue;
            
            // event
            BOOL eventOK = !events.count;
            for (SPDotaEvent *event in events) {
                if ([aItem.event_id isEqualToString:event.event_id]) {
                    eventOK = YES;
                    break;
                }
            }
            if ( !eventOK ) continue;
            
            [newItemArray addObject:aItem];
        }
    }
    
    // 去除空的分类
    NSIndexSet *noEmptyIndexes = [newItems indexesOfObjectsPassingTest:^BOOL(NSArray *obj, NSUInteger idx, BOOL *stop) {
        return obj.count > 0;
    }];
    NSArray *filteredItems = [newItems objectsAtIndexes:noEmptyIndexes];
    NSArray *filteredTitles = [self.fullTitles objectsAtIndexes:noEmptyIndexes];
    
    // 这里要至少要有一个列表
    self.filteredItems = filteredItems.count > 0 ? filteredItems : @[@[]];
    self.filteredTitles = filteredTitles.count > 0 ? filteredTitles : @[@"全部物品"];
}

#pragma mark - Display
- (NSArray<NSArray<SPItem *> *> *)displayItems
{
    return [self needFilter] ? self.filteredItems : self.fullItems;
}

- (NSArray<NSString *> *)displayTitles
{
    return [self needFilter] ? self.filteredTitles : self.fullTitles;
}

@end
