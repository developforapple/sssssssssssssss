//
//  SPItemEntranceConfig.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemEntranceConfig.h"
#import "SPDota2API.h"
#import "SPDataManager.h"
#import "SPItem.h"
#import "SPItemImageLoader.h"

@interface SPItemEntranceUnit () <YYModel>
@end

@implementation SPItemEntranceUnit
YYModelDefaultCode

+ (NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"lastImage"];
}

+ (instancetype)unitWithType:(SPItemEntranceType)type
{
    SPItemEntranceUnit *unit = [SPItemEntranceUnit new];
    unit.type = type;
    
    NSString *title;
    switch (type) {
        case SPItemEntranceTypeOffPrice:    title = @"今日特价";    break;
        case SPItemEntranceTypeEvent:       title = @"Dota2事件";    break;
        case SPItemEntranceTypeHeroItem:    title = @"英雄";    break;
        case SPItemEntranceTypeCourier:     title = @"信使";    break;
        case SPItemEntranceTypeWorld:       title = @"世界";    break;
        case SPItemEntranceTypeHud:         title = @"界面";    break;
        case SPItemEntranceTypeAudio:       title = @"音频";    break;
        case SPItemEntranceTypeTreasureBundle:    title = @"珍藏、捆绑包";    break;
        case SPItemEntranceTypeLeague:      title = @"联赛";    break;
        case SPItemEntranceTypeOther:       title = @"其他";    break;
        case SPItemEntranceTypeOnSale:      title = @"Dota2商店";    break;
        case SPItemEntranceTypeMarket:      title = @"Steam市场";    break;
    }
    unit.title = title;
    
    NSString *defaultImageName;
    switch (type) {
        case SPItemEntranceTypeOffPrice:    defaultImageName = @"Item_OffPrice";    break;
        case SPItemEntranceTypeEvent:       defaultImageName = @"TI7";    break;
        case SPItemEntranceTypeHeroItem:    defaultImageName = @"Item_Hero";    break;
        case SPItemEntranceTypeCourier:     defaultImageName = @"Item_Courier";    break;
        case SPItemEntranceTypeWorld:       defaultImageName = @"Item_World";    break;
        case SPItemEntranceTypeHud:         defaultImageName = @"Item_Hud";    break;
        case SPItemEntranceTypeAudio:       defaultImageName = @"Item_Audio";    break;
        case SPItemEntranceTypeTreasureBundle:    defaultImageName = @"Item_Treasure";    break;
        case SPItemEntranceTypeLeague:      defaultImageName = @"Item_Treasure";    break;
        case SPItemEntranceTypeOther:       defaultImageName = @"Item_Other";    break;
        case SPItemEntranceTypeOnSale:      defaultImageName = @"Item_OffPrice";    break;
        case SPItemEntranceTypeMarket:      defaultImageName = @"Item_OffPrice";    break;
    }
    unit.defaultImage = defaultImageName;
    return unit;
}

@end

NSString *const kSPItemEntranceConfigUnits = @"SPItemEntranceConfigUnits";

@implementation SPItemEntranceConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *units = [SPItemEntranceConfig savedUnits];
        if (!units) {
            units = @[[SPItemEntranceUnit unitWithType:SPItemEntranceTypeOffPrice],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeEvent],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeHeroItem],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeCourier],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeWorld],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeHud],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeAudio],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeTreasureBundle],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeLeague],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeOther],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeOnSale],
                      [SPItemEntranceUnit unitWithType:SPItemEntranceTypeMarket]];
            [SPItemEntranceConfig saveUnits:units];
        }
        self.units = units;
    }
    return self;
}

+ (NSArray<SPItemEntranceUnit *> *)savedUnits
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSPItemEntranceConfigUnits];
    NSArray *units = [NSArray yy_modelArrayWithClass:[SPItemEntranceUnit class] json:data];
    return units;
}

+ (void)saveUnits:(NSArray *)units
{
    RunOnGlobalQueue(^{
        NSData *data = [units yy_modelToJSONData];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSPItemEntranceConfigUnits];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (SPItemEntranceUnit *)unitOfType:(SPItemEntranceType)type
{
    for (SPItemEntranceUnit *aUnit in self.units) {
        if (aUnit.type == type) {
            return aUnit;
        }
    }
    return nil;
}

- (void)beginUpdateAuto
{
    for (SPItemEntranceUnit *unit in self.units) {
        [self updateUnitDelay:unit];
    }
}

- (void)updateUnitDelay:(SPItemEntranceUnit *)unit
{
    uint32_t min = 30;
    uint32_t max = 60;
    NSTimeInterval delay = min + arc4random_uniform((max-min)*1000+1) / 1000.0;
    RunAfter(delay, ^{
        [self updateUnit:unit];
    });
}

- (void)updateUnit:(SPItemEntranceUnit *)unit
{
    switch (unit.type) {
        case SPItemEntranceTypeOffPrice:{
            [self updateSpecialPriceUnit];
        }   break;
        case SPItemEntranceTypeEvent:
        case SPItemEntranceTypeOnSale:
        case SPItemEntranceTypeMarket:{
            // 不刷新这三个unit
        }   break;
        case SPItemEntranceTypeHeroItem:{
            //随机英雄图片
            [self updateHeroUnit];
        }   break;
        default:{
            //其余饰品分类
            [self updateItemsUnit:unit];
        }   break;
    }
}

- (void)updateHeroUnit
{
    SPItemEntranceUnit *unit = [self unitOfType:SPItemEntranceTypeHeroItem];
    RunOnGlobalQueue(^{
        NSArray *heroes = [SPDataManager shared].heroes;
        NSInteger random = arc4random_uniform((uint32_t)heroes.count);
        SPHero *hero = heroes[random];
        unit.imageUrl = [hero vertImageURL];
        [self didUpdateUnit:unit];
    });
}

- (void)updateItemsUnit:(SPItemEntranceUnit *)unit
{
    NSString *sql;
    switch (unit.type) {
        case SPItemEntranceTypeCourier:{
            sql = @"SELECT * FROM items WHERE prefab = 'courier' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeWorld:{
            sql = @"SELECT * FROM items WHERE prefab = 'ward' OR prefab = 'terrain' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeHud:{
            sql = @"SELECT * FROM items WHERE prefab = 'loading_screen' OR prefab = 'hud_skin' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeAudio:{
            sql = @"SELECT * FROM items WHERE prefab = 'music' OR prefab = 'announcer' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeTreasureBundle:{
            sql = @"SELECT * FROM items WHERE prefab = 'treasure_chest' OR prefab = 'bundle' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeLeague:{
            sql = @"SELECT * FROM items WHERE prefab = 'league' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        case SPItemEntranceTypeOther:{
            sql = @"SELECT * FROM items WHERE prefab = 'tool' OR prefab = 'taunt' OR prefab = 'misc' ORDER BY RANDOM() LIMIT 1;";
        }   break;
        default:
            break;
    }
    if (sql) {
        
        __block SPItem *item;
        
        SyncBenchmarkTestAndLog(^{
            SPDBWITHOPEN
            FMResultSet *result = [db executeQuery:sql];
            if ([result next]) {
                NSDictionary *dict = result.resultDictionary;
                item = [SPItem yy_modelWithDictionary:dict];
            }
            SPDBCLOSE
        });
        
        unit.imageUrl = [item qiniuLargeURL].absoluteString;
        [self didUpdateUnit:unit];
    }
}

- (void)updateSpecialPriceUnit
{
    SPItemEntranceUnit *unit = [self unitOfType:SPItemEntranceTypeOffPrice];
    if ([SPDota2MarketItem needUpdate]) {
        [SPDota2API fetchDota2SpecilPriceItem:^(SPDota2MarketItem *item) {
            unit.imageUrl = item.itemImageDropShadow;
            [self didUpdateUnit:unit];
        }];
    }else{
        NSString *url = [SPDota2MarketItem curItem].itemImageDropShadow;
        if ([unit.imageUrl isEqualToString:url]) {
            [self updateUnitDelay:unit];
        }else{
            [self didUpdateUnit:unit];
        }
    }
}

- (void)didUpdateUnit:(SPItemEntranceUnit *)unit
{
    RunOnMainQueue(^{
        if (self.unitDidUpdated) {
            self.unitDidUpdated(unit);
        }
        [self updateUnitDelay:unit];
    });
}

@end
