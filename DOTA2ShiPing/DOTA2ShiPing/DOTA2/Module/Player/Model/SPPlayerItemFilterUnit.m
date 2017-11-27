//
//  SPPlayerItemFilterUnit.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemFilterUnit.h"
#import "SPHero.h"

NSString *const kSPFilterObjectTradableYES = @"t_yes";
NSString *const kSPFilterObjectTradableNO = @"t_no";
NSString *const kSPFilterObjectMarketableYES = @"m_yes";
NSString *const kSPFilterObjectMarketableNO = @"m_no";

@implementation SPPlayerItemFilterUnit

+ (instancetype)unit:(NSString *)name object:(NSString *)object
{
    SPPlayerItemFilterUnit *unit = [[self class] new];
    unit.title = name;
    unit.object = object;
    return unit;
}

+ (instancetype)inputUnit
{
    SPPlayerItemFilterUnit *unit = [self unit:@"输入匹配文本" object:nil];
    unit.type = SPPlayerItemFilterTypeInput;
    unit.kind = SPFilterKindInput;
    return unit;
}

+ (instancetype)unit:(SPPlayerItemFilterType)type
               title:(NSString *)title
              object:(NSString *)object
{
    SPPlayerItemFilterUnit *unit = [self unit:title object:object];
    unit.type = type;
    return unit;
}

+ (instancetype)heroUnit:(SPHero *)hero
{
    SPPlayerItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = hero.name_loc;
    unit.object = hero;
    unit.type = SPPlayerItemFilterTypeHero;
    return unit;
}

+ (instancetype)emptyHeroUnit
{
    SPPlayerItemFilterUnit *unit = [[[self class] alloc] init];;
    unit.title = @"选择英雄";
    unit.object = nil;
    unit.type = SPPlayerItemFilterTypeHero;
    unit.isPlaceholder = YES;
    return unit;
}

- (void)updateHero:(SPHero *)hero
{
    if ([self type] == SPPlayerItemFilterTypeHero) {
        self.object = hero;
        self.title = hero ? hero.name_loc : @"选择英雄";
        self.isPlaceholder = !hero;
    }
}

+ (instancetype)tradableUnit:(BOOL)tradable
{
    SPPlayerItemFilterUnit *unit = [SPPlayerItemFilterUnit new];
    unit.title = tradable ? @"可交易" : @"不可交易" ;
    unit.object = tradable ? kSPFilterObjectTradableYES : kSPFilterObjectTradableNO ;
    unit.type = SPPlayerItemFilterTypeTradable;
    return unit;
}

+ (instancetype)marketableUnit:(BOOL)marketable
{
    SPPlayerItemFilterUnit *unit = [SPPlayerItemFilterUnit new];
    unit.title = marketable ? @"可出售" : @"不可出售" ;
    unit.object = marketable ? kSPFilterObjectMarketableYES : kSPFilterObjectMarketableNO ;
    unit.type = SPPlayerItemFilterTypeMarketable;
    return unit;
}

@end
