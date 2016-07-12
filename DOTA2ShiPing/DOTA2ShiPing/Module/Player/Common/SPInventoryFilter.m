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

// 分类排序过后的items
@property (strong, readwrite, nonatomic) NSArray<NSArray<SPPlayerItemDetail *> *> *items;
// 使用筛选条件进行筛选过后的items。没有进行分类和排序。
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *filteredItems;
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
        self.condition = [[SPInventoryFilterCondition alloc] init];
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
        case SPInventoryCategoryFilter:{
            [self showFilteredItems];
            break;
        }
    }
}

- (NSInteger)updateWithCondition:(SPInventoryFilterCondition *)condition
{
    self.condition = condition;
    
    if (!condition) {
        [self updateWithCategory:self.category];
        return 0;
    }

    // 算法1
    BOOL testTradeable  = condition.tradeable!=SPConditionOptionUndefined;  //是否检查交易类型
    BOOL isTradeable    = condition.tradeable==SPConditionOptionTrue;       //条件是否是可交易
    BOOL testMarketable = condition.markedable!=SPConditionOptionUndefined; //是否检查市场类型
    BOOL isMarketable   = condition.markedable==SPConditionOptionTrue;      //条件是否是可出售
    BOOL testQuality    = nil!=condition.quality;   //是否检查品质
    BOOL testHero       = nil!=condition.hero;      //是否检查英雄
    BOOL testRarity     = nil!=condition.rarity;    //是否检查稀有度
    
    NSIndexSet *indexSet =
    [self.baseItems indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
        return  (testTradeable  ?   (isTradeable?obj.tradable.boolValue:!obj.tradable.boolValue)            :YES) &&
                (testMarketable ?   (isMarketable?obj.marketable.boolValue:!obj.marketable.boolValue)       :YES) &&
                (testQuality    ?   [[obj qualityTag].internal_name isEqualToString:condition.quality.name] :YES) &&
                (testHero       ?   [[obj heroTag].internal_name isEqualToString:condition.hero.name]       :YES) &&
                (testRarity     ?   [[obj rarityTag].internal_name isEqualToString:condition.rarity.name]   :YES);
    }];
    self.filteredItems = [self.baseItems objectsAtIndexes:indexSet];
    return self.filteredItems.count;
    
    
    // 算法2
    
//    //开始筛选
//    if (condition.tradeable != SPConditionOptionUndefined) {
//        // 可交易
//        NSIndexSet *indexSet = [items indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
//            return !obj.tradable.boolValue;
//        }];
//        [items removeObjectsAtIndexes:indexSet];
//    }
//    
//    if (condition.markedable != SPConditionOptionUndefined) {
//        // 可出售
//        
//        NSIndexSet *indexSet = [items indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
//            return !obj.marketable.boolValue;
//        }];
//        [items removeObjectsAtIndexes:indexSet];
//    }
//    
//    if (condition.quality) {
//        // 品质可以去掉大多数饰品
//        NSIndexSet *indexSet = [items indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
//            SPPlayerInvertoryItemTag *tag = [obj qualityTag];
//            return ![tag.internal_name isEqualToString:condition.quality.name];
//        }];
//        [items removeObjectsAtIndexes:indexSet];
//    }
//    
//    if (condition.hero) {
//        // 英雄
//        NSIndexSet *indexSet = [items indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
//            SPPlayerInvertoryItemTag *tag = [obj heroTag];
//            return ![tag.internal_name isEqualToString:condition.hero.name];
//        }];
//        [items removeObjectsAtIndexes:indexSet];
//    }
//    
//    if (condition.rarity) {
//        //稀有度
//        NSIndexSet *indexSet = [items indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(SPPlayerItemDetail *obj, NSUInteger idx, BOOL *stop) {
//            SPPlayerInvertoryItemTag *tag = [obj heroTag];
//            return ![tag.internal_name isEqualToString:condition.rarity.name];
//        }];
//        [items removeObjectsAtIndexes:indexSet];
//    }
//    
//    // 这里不更新UI 只临时保存结果 所以不回调
//    // 如果要更新UI 需要使用 SPInventoryCategoryFilter 这个类别来更新
//    self.filteredItems = items;
//    return items.count;
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
        case SPInventoryCategoryFilter:
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

- (void)showFilteredItems
{
    NSArray *items = self.filteredItems;
    
    //在这里进行分类排序
    if (self.condition.hero) {
        // 有英雄这个条件 就根据英雄的部位来分类
        
        //TODO
        
    }else{
        // 其他情况下 只有一个分类
        
        NSMutableArray *tmp = [NSMutableArray array];
        if (self.condition.quality) {
            NSString *name = self.condition.quality.name_cn;
            [tmp addObject:name];
        }
        if (self.condition.rarity){
            [tmp addObject:self.condition.rarity.name_cn];
        }
        if (self.condition.tradeable != SPConditionOptionUndefined) {
            [tmp addObject:[self.condition tradeableLocalString]];
        }
        if (self.condition.markedable != SPConditionOptionUndefined) {
            [tmp addObject:[self.condition marketableLocalString]];
        }
        NSString *title = [tmp componentsJoinedByString:@" + "];
        self.titles = @[title];
        self.items = @[items];
    }
    if (self.updateCallback) {
        self.updateCallback();
    }
}

@end

@implementation SPInventoryFilterCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tradeable = SPConditionOptionUndefined;
        self.markedable = SPConditionOptionUndefined;
    }
    return self;
}

- (NSString *)tradeableLocalString
{
    switch (self.tradeable) {
        case SPConditionOptionUndefined: {
            return @"不限制";
            break;
        }
        case SPConditionOptionTrue: {
            return @"可交易";
            break;
        }
        case SPConditionOptionFalse: {
            return @"不可交易";
            break;
        }
    }
    return nil;
}

- (NSString *)marketableLocalString
{
    switch (self.markedable) {
        case SPConditionOptionUndefined: {
            return @"不限制";
            break;
        }
        case SPConditionOptionTrue: {
            return @"可出售";
            break;
        }
        case SPConditionOptionFalse: {
            return @"不可出售";
            break;
        }
    }
    return nil;
}

@end
