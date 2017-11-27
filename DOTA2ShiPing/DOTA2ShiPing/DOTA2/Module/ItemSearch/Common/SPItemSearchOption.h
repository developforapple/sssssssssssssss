//
//  SPItemSearchOption.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPItemSearchCommon.h"

@class SPHero;
@class SPItemRarity;
@class SPItemQuality;
@class SPItemPrefab;
@class SPDotaEvent;

@interface SPItemSearchOption : SPObject

- (instancetype)initWithKinds:(SPItemSearchKind)kinds;

@property (assign, readonly, nonatomic) SPItemSearchKind kinds;

@property (copy, nonatomic) NSString *keywords;
@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPItemQuality *quality;
@property (strong, nonatomic) SPItemPrefab *prefab;
@property (strong, nonatomic) SPDotaEvent *event;
@property (assign, nonatomic) SPConditionOption tradable;
@property (assign, nonatomic) SPConditionOption marketable;
- (NSString *)tradeableLocalString;
- (NSString *)marketableLocalString;
@end
