//
//  SPItemFilter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemFilter.h"

#import "FMDB.h"
#import "SPDataManager.h"

@implementation SPItemFilter

+ (instancetype)filterWithHero:(SPHero *)hero
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.hero = hero;
    filter.filterTitle = hero.name_loc;
    return filter;
}

+ (instancetype)filterWithPerfabs:(NSArray<SPItemPrefab *> *)prefabs
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.prefabs = prefabs;
    return filter;
}

+ (instancetype)filterWithEvent:(SPDotaEvent *)event
{
    SPItemFilter *filter = [SPItemFilter new];
    filter.event = event;
    filter.filterTitle = event.name_loc;
    return filter;
}

+ (instancetype)filterWithKeywords:(NSString *)keywords
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.keywords = keywords;
    filter.filterTitle = keywords;
    return filter;
}

+ (instancetype)filterWithItemNames:(NSArray<NSString *> *)itemNames
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.itemNames = itemNames;
    return filter;
}

- (BOOL)updateItems
{
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
            NSLog(@"%@",error);
            suc = NO;
            return ;
        }
        NSMutableArray *items = [NSMutableArray array];
        while ([result nextWithError:&error]) {
            NSDictionary *dict = result.resultDictionary;
            SPItem *item = [SPItem yy_modelWithDictionary:dict];
            [items addObject:item];
        }
        if (error) {
            [result close];
            SPDBCLOSE
            NSLog(@"%@",error);
            suc = NO;
            return;
        }
        
        self.items = items;
        SPDBCLOSE
        
    }, ^(double ms) {
        NSLog(@"\n\n\tsql:%@ \n\n\t耗时：%.3f ms\n\n ",sql,ms);
    });
    
    return suc;
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
    
    self.separatedItems = temp;
    self.titles = segmentTitles;
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
                NSLog(@"找到一个未知 itemSlot ： %@",itemslot);
            }
        }else if([item isTaunt]){
            NSInteger index = [slotNames indexOfObject:@"taunt"];
            if (index != NSNotFound) {
                [slotItems[index] addObject:item];
            }else{
                [others addObject:item];
                NSLog(@"饰品为嘲讽，但是英雄没有嘲讽槽位。需要解决这个问题！");
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
    
    self.separatedItems = items;
    self.titles = segmentTitles;
}

@end
