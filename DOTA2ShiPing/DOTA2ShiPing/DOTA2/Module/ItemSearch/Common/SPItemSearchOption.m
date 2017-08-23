//
//  SPItemSearchOption.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSearchOption.h"

@interface SPItemSearchOption ()
@property (assign, readwrite, nonatomic) SPItemSearchKind kinds;
@end

@implementation SPItemSearchOption

- (instancetype)initWithKinds:(SPItemSearchKind)kinds
{
    self = [super init];
    if (self) {
        self.kinds = kinds;
        self.tradable = SPConditionOptionUndefine;
        self.marketable = SPConditionOptionUndefine;
    }
    return self;
}

- (void)setKeywords:(NSString *)keywords
{
    _keywords = _kinds & SPItemSearchKindKeywords ? keywords : nil;
}

- (void)setHero:(SPHero *)hero
{
    _hero = _kinds & SPItemSearchKindHero ? hero : nil;
}

- (void)setRarity:(SPItemRarity *)rarity
{
    _rarity = _kinds & SPItemSearchKindRarity ? rarity : nil;
}

- (void)setQuality:(SPItemQuality *)quality
{
    _quality = _kinds & SPItemSearchKindQuality ? quality : nil;
}

- (void)setPrefab:(SPItemPrefab *)prefab
{
    _prefab = _kinds & SPItemSearchKindPrefab ? prefab : nil;
}

- (void)setEvent:(SPDotaEvent *)event
{
    _event = _kinds & SPItemSearchKindEvent ? event : nil;
}

- (void)setTradable:(SPConditionOption)tradable
{
    _tradable = _kinds & SPItemSearchKindTradable ? tradable : SPConditionOptionUndefine;
}

- (void)setMarketable:(SPConditionOption)marketable
{
    _marketable = _kinds & SPItemSearchKindMarketable ? marketable : SPConditionOptionUndefine;
}

- (NSString *)tradeableLocalString
{
    switch (self.tradable) {
        case SPConditionOptionUndefine: {
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
    switch (self.marketable) {
        case SPConditionOptionUndefine: {
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
