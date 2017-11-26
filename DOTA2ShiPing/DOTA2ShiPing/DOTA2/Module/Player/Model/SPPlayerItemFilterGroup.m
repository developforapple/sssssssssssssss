//
//  SPPlayerItemFilterGroup.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemFilterGroup.h"
#import "SPPlayerItemFilterUnit.h"

@implementation SPPlayerItemFilterGroup

+ (instancetype)inputGroup
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"匹配物品名称";
    group.units = @[[SPPlayerItemFilterUnit inputUnit]];
    group.type = SPPlayerItemFilterTypeInput;
    return group;
}

+ (instancetype)heroGroup:(SPPlayerItemFilterUnit *)unit
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"英雄";
    group.units = unit ? @[unit] : @[];
    group.type = SPPlayerItemFilterTypeHero;
    return group;
}

+ (instancetype)qualityGroup:(NSArray<SPPlayerItemFilterUnit *> *)qualities
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"品质";
    group.type = SPPlayerItemFilterTypeQuality;
    group.units = qualities;
    return group;
}

+ (instancetype)rarityGroup:(NSArray<SPPlayerItemFilterUnit *> *)rarities
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"稀有度";
    group.type = SPPlayerItemFilterTypeRarity;
    group.units = rarities;
    return group;
}

+ (instancetype)prefabGroup:(NSArray<SPPlayerItemFilterUnit *> *)prefabs
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"类型";
    group.type = SPPlayerItemFilterTypePrefab;
    group.units = prefabs;
    return group;
}

+ (instancetype)slotGroup:(NSArray<SPPlayerItemFilterUnit *> *)slots
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"槽位";
    group.type = SPPlayerItemFilterTypeSlot;
    group.units = slots;
    return group;
}

+ (instancetype)tradableGroup
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"可否交易";
    group.type = SPPlayerItemFilterTypeTradable;
    group.units = @[[SPPlayerItemFilterUnit tradableUnit:YES],
                    [SPPlayerItemFilterUnit tradableUnit:NO]];
    return group;
}

+ (instancetype)marketableGroup
{
    SPPlayerItemFilterGroup *group = [[[self class] alloc] init];
    group.headerTitle = @"可否出售";
    group.type = SPPlayerItemFilterTypeMarketable;
    group.units = @[[SPPlayerItemFilterUnit marketableUnit:YES],
                    [SPPlayerItemFilterUnit marketableUnit:NO]];
    return group;
}

@end
