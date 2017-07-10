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

@interface SPItemFilter ()
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation SPItemFilter

+ (instancetype)filterWithHero:(SPHero *)hero
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.hero = hero;
    filter.filterTitle = hero.name_cn;
    return filter;
}

+ (instancetype)filterWithPerfabs:(NSArray<SPItemPrefab *> *)prefabs
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.prefabs = prefabs;
    return filter;
}

+ (instancetype)filterWithKeywords:(NSString *)keywords
{
    SPItemFilter *filter = [[SPItemFilter alloc] init];
    filter.keywords = keywords;
    filter.filterTitle = keywords;
    return filter;
}

- (void)dealloc
{
    [_db close];
}

- (FMDatabase *)db
{
    if (!_db) {
        _db = [[SPDataManager shared] db];
        [_db open];
    }
    return _db;
}

- (BOOL)updateItems
{
    NSString *sql = @"SELECT * FROM items WHERE ";
    
    NSMutableArray *query = [NSMutableArray array];
    NSMutableArray *params = [NSMutableArray array];
    
    if (self.hero) {
        [query addObject:@" heroes LIKE ? "];
        [params addObject:[NSString stringWithFormat:@"%%%@%%",self.hero.name]];
    }
    if (self.prefabs) {
        NSMutableArray *prefabQuery = [NSMutableArray array];
        for (SPItemPrefab *prefab in self.prefabs) {
            [prefabQuery addObject:@" prefab = ? "];
            [params addObject:prefab.name];
        }
        [query addObject:[NSString stringWithFormat:@"(%@)",[prefabQuery componentsJoinedByString:@" OR "]]];
    }
    if (self.keywords) {
        [query addObject:@" (name LIKE ? OR item_name LIKE ?) "];
        [params addObject:[NSString stringWithFormat:@"%%%@%%",self.keywords]];
        [params addObject:[NSString stringWithFormat:@"%%%@%%",self.keywords]];
    }
    
    if (self.rarity) {
        [query addObject:@" rarity = ? "];
        [params addObject:self.rarity.name];
    }
    
    sql = [sql stringByAppendingString:[query componentsJoinedByString:@" AND "]];
    
    NSError *error;
    FMResultSet *result = [self.db executeQuery:sql values:params error:&error];
    
    if (error) {
        [result close];
        NSLog(@"%@",error);
        return NO;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    while ([result nextWithError:&error]) {
        NSDictionary *dict = result.resultDictionary;
        SPItem *item = [SPItem yy_modelWithDictionary:dict];
        [items addObject:item];
    }
    if (error) {
        [result close];
        NSLog(@"%@",error);
        return NO;
    }
    self.items = items;
    [result close];
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
            completion(suc,self.items);
        }
    });
}

- (void)separateItem
{
    if (self.hero) {
        NSMutableArray *bundles = [NSMutableArray array];
        
        NSMutableArray *slotItems = [NSMutableArray array];
        NSMutableArray *slotNames = [NSMutableArray array];
        for (SPItemSlot *slot in self.hero.slot) {
            [slotNames addObject:slot.name];
            [slotItems addObject:[NSMutableArray array]];
        }
        
        NSMutableArray *others = [NSMutableArray array];
        
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
                    NSLog(@"找到一个BUGGGGGGGGGG!!!!");
                }
            }else{
                [others addObject:item];
            }
        }
        
        NSMutableArray *segmentTitles = [NSMutableArray array];
        
        if (bundles.count != 0) {
            [segmentTitles addObject:[NSString stringWithFormat:@"套装 %lu",(unsigned long)bundles.count]];
        }else{
            [segmentTitles addObject:@"套装"];
        }
        
        for (SPItemSlot *slot in self.hero.slot) {
            NSUInteger index = [self.hero.slot indexOfObject:slot];
            NSString *name = slot.name_cn_hero;
            NSUInteger count = [slotItems[index] count];
            
            if (count != 0) {
                [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",name,(unsigned long)count]];
            }else{
                [segmentTitles addObject:name];
            }
        }
        if (others.count != 0) {
            [segmentTitles addObject:[NSString stringWithFormat:@"其它 %lu",(unsigned long)others.count]];
        }else{
            [segmentTitles addObject:@"其它"];
        }
        
        NSMutableArray *items = [NSMutableArray arrayWithObject:bundles];
        [items addObjectsFromArray:slotItems];
        [items addObject:others];
        
        self.separatedItems = items;
        self.titles = segmentTitles;
    }else{
        
        NSArray *prefabs;
        if (self.keywords) {
            NSMutableSet *prefabSet = [NSMutableSet set];
            for (SPItem *item in self.items) {
                NSString *prefabName = item.prefab;
                if (prefabName) {
                    [prefabSet addObject:prefabName];
                }
            }
            prefabs = [[SPDataManager shared] prefabsOfNames:[prefabSet allObjects]];
        }else{
            prefabs = self.prefabs;
        }
        
        NSMutableArray *temp = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        
        NSMutableArray *prefabNames = [NSMutableArray array];
        for (SPItemPrefab *prefab in prefabs) {
            [prefabNames addObject:prefab.name];
            [titles addObject:prefab.name_cn];
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
            if (count != 0) {
                [segmentTitles addObject:[NSString stringWithFormat:@"%@ %lu",title,(unsigned long)count]];
            }else{
                [segmentTitles addObject:title];
            }
        }
        
        if (others.count != 0) {
            [temp addObject:others];
            [segmentTitles addObject:[NSString stringWithFormat:@"其它 %lu",(unsigned long)others.count]];
        }
        
        self.separatedItems = temp;
        self.titles = segmentTitles;
    }
}

@end
