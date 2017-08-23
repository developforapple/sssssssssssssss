//
//  SPItemSearchCommon.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#ifndef SPItemSearchCommon_h
#define SPItemSearchCommon_h

typedef NS_OPTIONS(NSUInteger, SPItemSearchKind) {
    SPItemSearchKindKeywords = 1 << 0,
    SPItemSearchKindHero = 1 << 1,
    SPItemSearchKindRarity = 1 << 2,
    SPItemSearchKindQuality = 1 << 3,
    SPItemSearchKindPrefab = 1 << 4,
    SPItemSearchKindEvent = 1 << 5,
    SPItemSearchKindTradable = 1 << 6,
    SPItemSearchKindMarketable = 1 << 7,
};

#define SPItemSearchKindAll ~(NSUInteger)0

#define SPItemSearchKindHeroItem \
    (SPItemSearchKindKeywords | SPItemSearchKindRarity | SPItemSearchKindQuality | SPItemSearchKindEvent)

#define SPItemSearchKindGeneralItem \
    (SPItemSearchKindKeywords | SPItemSearchKindHero | SPItemSearchKindRarity | SPItemSearchKindQuality | SPItemSearchKindEvent)

#define SPItemSearchKindPlayerItem SPItemSearchKindAll

typedef NS_ENUM(NSUInteger, SPConditionOption) {
    SPConditionOptionTrue = 2,
    SPConditionOptionFalse = 0,
    SPConditionOptionUndefine = 1,
};

#endif /* SPItemSearchCommon_h */
