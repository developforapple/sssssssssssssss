//
//  SPItemFilterUnit.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemFilterUnit.h"
#import "SPItemFilterDefine.h"
#import "SPItemRarity.h"
#import "SPHero.h"
#import "SPDotaEvent.h"

@implementation SPItemFilterUnit

+ (instancetype)inputUnit
{
    SPItemFilterUnit *unit = [[[self class] alloc] init];
    unit.title = @"输入匹配文本";
    unit.kind = SPFilterKindInput;
    unit.type = SPItemFilterTypeInput;
    return unit;
}

+ (instancetype)itemRarityUnit:(SPItemRarity *)rarity
{
    SPItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = rarity.name_loc;
    unit.object = rarity;
    unit.type = SPItemFilterTypeRarity;
    return unit;
}

+ (instancetype)itemHeroUnit:(SPHero *)hero
{
    SPItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = hero.name_loc;
    unit.object = hero;
    unit.type = SPItemFilterTypeHero;
    return unit;
}

+ (instancetype)itemEmptyHeroUnit
{
    SPItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = @"选择英雄";
    unit.object = nil;
    unit.type = SPItemFilterTypeHero;
    unit.isPlaceholder = YES;
    return unit;
}

+ (instancetype)itemEventUnit:(SPDotaEvent *)event
{
    SPItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = event.name_loc ? : event.event_id;
    unit.object = event;
    unit.type = SPItemFilterTypeEvent;
    return unit;
}

- (void)itemUpdateHero:(SPHero *)hero
{
    if ([self type] == SPItemFilterTypeHero) {
        self.object = hero;
        self.title = hero ? hero.name_loc : @"选择英雄";
        self.isPlaceholder = !hero;
    }
}

@end
