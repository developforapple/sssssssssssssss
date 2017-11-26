//
//  SPItemFilterUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterUnit.h"
#import "SPItemFilterDefine.h"

@class SPFilterOption;
@class SPItemRarity;
@class SPHero;
@class SPDotaEvent;

@interface SPItemFilterUnit : SPFilterUnit

@property (assign, nonatomic) BOOL isPlaceholder;

+ (instancetype)inputUnit;
+ (instancetype)itemRarityUnit:(SPItemRarity *)rarity;
+ (instancetype)itemHeroUnit:(SPHero *)hero;
+ (instancetype)itemEmptyHeroUnit;
+ (instancetype)itemEventUnit:(SPDotaEvent *)event;

- (void)itemUpdateHero:(SPHero *)hero;

- (SPItemFilterType)type;

@end
