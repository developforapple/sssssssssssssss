//
//  SPItemFilterGroup.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterGroup.h"
#import "SPItemFilterDefine.h"

@class SPItemFilterUnit;
@class SPItemRarity;
@class SPHero;
@class SPDotaEvent;

@interface SPItemFilterGroup : SPFilterGroup

+ (instancetype)itemInputGroup;
+ (instancetype)itemRarityGroup:(NSArray<SPItemRarity *> *)rarities;
+ (instancetype)itemEventGroup:(NSArray<SPDotaEvent *> *)events;
+ (instancetype)itemHeroGroup:(SPItemFilterUnit *)unit;

- (SPItemFilterType)type;

@end
