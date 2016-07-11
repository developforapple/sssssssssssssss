//
//  SPInventoryFilter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPInventoryFilter.h"
#import "SPDataManager.h"

@interface SPInventoryFilter ()
// 库存数据
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *baseItems;

// 筛选排序过后的items
@property (strong, readwrite, nonatomic) NSArray<NSArray<SPPlayerItemDetail *> *> *items;
// 筛选排序过后的标题
@property (strong, readwrite, nonatomic) NSArray<NSString *> *titles;

@end

@implementation SPInventoryFilter

- (instancetype)initWithPlayer:(SPPlayer *)player
{
    self = [super init];
    if (self) {
        self->_player = player;
        self.baseItems = self.player.inventory.items;
    }
    return self;
}

- (void)updateWithCategory:(SPInventoryCategory)category
{
    switch (category) {
        case SPInventoryCategoryAll: {
            [self showAllItems];
            break;
        }
        case SPInventoryCategoryEvent: {
            [self showEventItems];
            break;
        }
        case SPInventoryCategoryHero: {
            [self showHeroItems];
            break;
        }
        case SPInventoryCategoryCourier:
        case SPInventoryCategoryWorld:
        case SPInventoryCategoryHud:
        case SPInventoryCategoryAudio:
        case SPInventoryCategoryTreasure:
        case SPInventoryCategoryOther: {
            [self filterItemsWithCategory:category];
            break;
        }
        case SPInventoryCategoryTradableSaleable:{
            [self showTradableSaleableItems];
            break;
        }
    }
}

// 全部饰品
- (void)showAllItems
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (SPPlayerItemDetail *item in self.baseItems) {
        SPPlayerInvertoryItemTag *tag = [item rarityTag];
        NSString *name = tag.name;
        NSMutableArray *tmp = dict[name];
        if (!tmp) {
            tmp = [NSMutableArray array];
            dict[name] = tmp;
        }
        [tmp addObject:item];
    }
    
    NSArray *titles = [dict allKeys];
    NSArray *values = [dict objectsForKeys:titles notFoundMarker:[NSArray array]];
    
    NSMutableArray *fullTitles = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < values.count; idx ++ ) {
        NSString *t = titles[idx];
        NSUInteger c = [values[idx] count];
        NSString *title = [NSString stringWithFormat:@"%@ %lu",t,(unsigned long)c];
        [fullTitles addObject:title];
    }
    self.titles = fullTitles;
    self.items = values;
    
    if (self.updateCallback) {
        self.updateCallback();
    }
}

// 带事件的饰品
- (void)showEventItems
{
    FMDatabase *db = [SPDataManager shared].db;
    FMResultSet *result = [db executeQuery:@"SELECT token,event_id FROM items WHERE event_id <> '';"];
    int tokenIndex = [result columnIndexForName:@"token"];
    int eventidIndex = [result columnIndexForName:@"event_id"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([result next]) {
        NSNumber *token = @([result intForColumnIndex:tokenIndex]);
        NSString *event_id = [result stringForColumnIndex:eventidIndex];
        dict[token] = event_id;
    }
    [result close];
    
    NSMutableDictionary *filterResult = [NSMutableDictionary dictionary];
    for (SPPlayerItemDetail *item in self.baseItems) {
        NSNumber *defindex = item.defindex;
        NSString *event_id = dict[defindex];
        if (event_id) {
            //包含了一个事件
            NSMutableArray *eventItems = filterResult[event_id];
            if (!eventItems) {
                eventItems = [NSMutableArray array];
                filterResult[event_id] = eventItems;
            }
            [eventItems addObject:item];
        }
    }
    
    NSArray *eventTitles = [filterResult allKeys];
    NSArray *items = [filterResult objectsForKeys:eventTitles notFoundMarker:[NSArray array]];
    self.titles = eventTitles;
    self.items = items;
    if (self.updateCallback) {
        self.updateCallback();
    }
}

// 带英雄的饰品
- (void)showHeroItems
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (SPPlayerItemDetail *item in self.baseItems) {
        SPPlayerInvertoryItemTag *tag = [item heroTag];
        NSString *name = tag.name;
        NSMutableArray *tmp = dict[name];
        if (!tmp) {
            tmp = [NSMutableArray array];
            dict[name] = tmp;
        }
        [tmp addObject:item];
    }
    
    NSArray *titles = [dict allKeys];
    NSArray *values = [dict objectsForKeys:titles notFoundMarker:[NSArray array]];
    
    NSMutableArray *fullTitles = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < values.count; idx ++ ) {
        NSString *t = titles[idx];
        NSUInteger c = [values[idx] count];
        NSString *title = [NSString stringWithFormat:@"%@ %lu",t,(unsigned long)c];
        [fullTitles addObject:title];
    }
    self.titles = fullTitles;
    self.items = values;
    
    if (self.updateCallback) {
        self.updateCallback();
    }
}

- (void)filterItemsWithCategory:(SPInventoryCategory)category
{
    NSArray *prefabs = [self filterPrefabs:category];
    if (!prefabs) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (SPPlayerItemDetail *item in self.baseItems) {
        SPPlayerInvertoryItemTag *tag = [item typeTag];
        
        NSString *internal_name = tag.internal_name;
        NSString *name = tag.name;
        
        for (NSString *prefab in prefabs) {
            if ([prefab isEqualToString:internal_name]) {
                
                NSMutableArray *tmp = dict[name];
                if (!tmp) {
                    tmp = [NSMutableArray array];
                    dict[name] = tmp;
                }
                [tmp addObject:item];
                break;
            }
        }
    }
    
    NSArray *titles = [dict allKeys];
    NSArray *items = [dict objectsForKeys:titles notFoundMarker:[NSArray array]];
    self.titles = titles;
    self.items = items;
    if (self.updateCallback) {
        self.updateCallback();
    }
}

- (void)showTradableSaleableItems
{
    NSMutableArray *tradableList = [NSMutableArray array];
    NSMutableArray *marketableList = [NSMutableArray array];
    
    for (SPPlayerItemDetail *item in self.baseItems) {
        BOOL tradable = item.tradable.boolValue;    //可交易
        BOOL marketable = item.marketable.boolValue;//可出售
        if (tradable) {
            [tradableList addObject:item];
        }
        if (marketable) {
            [marketableList addObject:item];
        }
    }
    
    self.titles = @[[NSString stringWithFormat:@"可交易 %lu",(unsigned long)tradableList.count],
                    [NSString stringWithFormat:@"可出售 %lu",(unsigned long)marketableList.count]];
    self.items = @[tradableList,marketableList];
    if (self.updateCallback) {
        self.updateCallback();
    }
}


- (NSArray *)filterPrefabs:(SPInventoryCategory)category
{
    switch (category) {
        case SPInventoryCategoryAll:
        case SPInventoryCategoryEvent:
        case SPInventoryCategoryHero:
        case SPInventoryCategoryTradableSaleable:
            break;
        case SPInventoryCategoryCourier: {
            return @[@"courier",@"courier_wearable",@"modifier"];
            break;
        }
        case SPInventoryCategoryWorld: {
            return @[@"ward",@"weather",@"terrain",@"summons"];
            break;
        }
        case SPInventoryCategoryHud: {
            return @[@"cursor_pack",@"hud_skin",@"loading_screen",@"pennant"];
            break;
        }
        case SPInventoryCategoryAudio: {
            return @[@"music",@"announcer"];
            break;
        }
        case SPInventoryCategoryTreasure: {
            return @[@"treasure_chest",@"retired_treasure_chest",@"key"];
            break;
        }
        case SPInventoryCategoryOther: {
            return @[@"blink_effect",@"tool",@"emoticon_tool",@"player_card",@"teleport_effect",@"misc",@"dynamic_recipe",@"league",@"passport_fantasy_team",@"socket_gem",@"taunt"];
            break;
        }
    }
    return nil;
}

- (NSArray *)itemsWithKeywords:(NSString *)keywords
{
    if (!keywords || keywords.length == 0) return nil;
    
    //超过两个字才会进行品质搜索
    SPItemQuality *quality;
    if (keywords.length >= 2) {
        NSArray *qualities = [SPDataManager shared].qualities;
        for (SPItemQuality *q in qualities) {
            if ([q.name_cn containsString:keywords]) {
                quality = q;
                break;
            }
        }
    }
    
    // 超过两个字才会进行英雄搜索。 搜索到了品质就不会搜索英雄。
    SPHero *hero;
    if (keywords.length >= 2 && !quality) {
        NSArray *heroes = [SPDataManager shared].heroes;
        for (SPHero *h in heroes) {
            if ([h.name_cn containsString:keywords]) {
                hero = h;
                break;
            }
        }
    }
    
    // 开始匹配
    NSMutableArray *array = [NSMutableArray array];
    for (SPPlayerItemDetail *item in self.baseItems) {
        if (quality) {
            SPPlayerInvertoryItemTag *tag = item.qualityTag;
            if ([tag.internal_name isEqualToString:quality.name]) {
                [array addObject:item];
                continue;
            }
        }
        if (hero){
            SPPlayerInvertoryItemTag *tag = item.heroTag;
            if ([tag.internal_name isEqualToString:hero.name]) {
                [array addObject:item];
                continue;
            }
        }
        if ([item.market_name containsString:keywords]) {
            [array addObject:item];
        }
    }
    return array;
}

@end


