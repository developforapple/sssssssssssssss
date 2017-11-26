//
//  SPPlayerItemFilterGroup.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterGroup.h"
#import "SPPlayerItemFilterDefine.h"

@class SPHero;
@class SPPlayerItemFilterUnit;

@interface SPPlayerItemFilterGroup : SPFilterGroup

+ (instancetype)inputGroup;
+ (instancetype)heroGroup:(SPPlayerItemFilterUnit *)unit;
+ (instancetype)qualityGroup:(NSArray<SPPlayerItemFilterUnit *> *)qualities;
+ (instancetype)rarityGroup:(NSArray<SPPlayerItemFilterUnit *> *)rarities;
+ (instancetype)prefabGroup:(NSArray<SPPlayerItemFilterUnit *> *)prefabs;
+ (instancetype)slotGroup:(NSArray<SPPlayerItemFilterUnit *> *)slots;
+ (instancetype)tradableGroup;
+ (instancetype)marketableGroup;

- (SPPlayerItemFilterType)type;

@end
