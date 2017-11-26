//
//  SPItemFilterGroup.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemFilterGroup.h"
#import "SPItemFilterUnit.h"
#import "SPItemRarity.h"
#import "SPHero.h"
#import "SPDotaEvent.h"
#import "SPItemFilterDefine.h"

@implementation SPItemFilterGroup

+ (instancetype)itemInputGroup
{
    SPItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"匹配物品名称";
    group.units = @[[SPItemFilterUnit inputUnit]];
    group.type = SPItemFilterTypeInput;
    return group;
}

+ (instancetype)itemRarityGroup:(NSArray<SPItemRarity *> *)rarities
{
    NSMutableArray *array = [NSMutableArray array];
    for (SPItemRarity *aRarity in rarities) {
        SPFilterUnit *aUnit = [SPItemFilterUnit itemRarityUnit:aRarity];
        if (aUnit) {
            [array addObject:aUnit];
        }
    }
    SPItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"物品稀有度";
    group.units = array;
    group.type = SPItemFilterTypeRarity;
    return group;
}

+ (instancetype)itemEventGroup:(NSArray<SPDotaEvent *> *)events
{
    NSMutableArray *array = [NSMutableArray array];
    for (SPDotaEvent *aEvent in events) {
        SPFilterUnit *aUnit = [SPItemFilterUnit itemEventUnit:aEvent];
        if (aUnit) {
            [array addObject:aUnit];
        }
    }
    SPItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"Dota2事件";
    group.units = array;
    group.type = SPItemFilterTypeEvent;
    return group;
}

+ (instancetype)itemHeroGroup:(SPItemFilterUnit *)unit
{
    SPItemFilterGroup *group = [[[self class] alloc] init];;
    group.headerTitle = @"适用英雄";
    group.units = unit ? @[unit] : @[];
    group.type = SPItemFilterTypeHero;
    return group;
}

@end
