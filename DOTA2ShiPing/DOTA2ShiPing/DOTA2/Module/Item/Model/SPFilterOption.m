//
//  SPFilterOption.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterOption.h"
#import "SPItemRarity.h"
#import "SPHero.h"
#import "SPDotaEvent.h"

@interface SPFilterOptionGroup ()

@end

@implementation SPFilterOptionGroup
+ (instancetype)rarityGroup:(NSArray<SPItemRarity *> *)rarities
{
    NSMutableArray *array = [NSMutableArray array];
    for (SPItemRarity *aRarity in rarities) {
        SPFilterOption *aOption = [SPFilterOption rarityOption:aRarity];
        if (aOption) {
            [array addObject:aOption];
        }
    }
    SPFilterOptionGroup *group = [SPFilterOptionGroup new];
    group.title = @"稀有度";
    group.options = array;
    group.type = SPFilterOptionTypeRarity;
    return group;
}

+ (instancetype)eventGroup:(NSArray<SPDotaEvent *> *)events
{
    NSMutableArray *array = [NSMutableArray array];
    for (SPDotaEvent *aEvent in events) {
        SPFilterOption *aOption = [SPFilterOption eventOption:aEvent];
        if (aOption) {
            [array addObject:aOption];
        }
    }
    SPFilterOptionGroup *group = [SPFilterOptionGroup new];
    group.title = @"事件";
    group.options = array;
    group.type = SPFilterOptionTypeEvent;
    return group;
}

+ (instancetype)heroGroup:(SPFilterOption *)option
{
    SPFilterOptionGroup *group = [SPFilterOptionGroup new];
    group.title = @"英雄";
    group.options = option ? @[option] : @[];
    group.type = SPFilterOptionTypeHero;
    return group;
}

@end

@interface SPFilterOption ()

@end

@implementation SPFilterOption
+ (instancetype)rarityOption:(SPItemRarity *)rarity
{
    SPFilterOption *option = [SPFilterOption new];
    option.name = rarity.name_loc;
    option.option = rarity;
    option.type = SPFilterOptionTypeRarity;
    return option;
}

+ (instancetype)heroOption:(SPHero *)hero
{
    SPFilterOption *option = [SPFilterOption new];
    option.name = hero.name_loc;
    option.option = hero;
    option.type = SPFilterOptionTypeHero;
    return option;
}

+ (instancetype)emptyHeroOption
{
    SPFilterOption *option = [SPFilterOption new];
    option.name = @"选择英雄";
    option.option = nil;
    option.type = SPFilterOptionTypeHero;
    return option;
}

+ (instancetype)eventOption:(SPDotaEvent *)event
{
    SPFilterOption *option = [SPFilterOption new];
    option.name = event.name_loc ? : event.event_id;
    option.option = event;
    option.type = SPFilterOptionTypeEvent;
    return option;
}

- (void)updateHero:(SPHero *)hero
{
    if (self.type == SPFilterOptionTypeHero) {
        self.option = hero;
        self.name = hero ? hero.name_loc : @"选择英雄";
    }
}
@end
