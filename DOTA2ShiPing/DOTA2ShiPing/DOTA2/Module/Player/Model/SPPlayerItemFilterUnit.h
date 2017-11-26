//
//  SPPlayerItemFilterUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterUnit.h"
#import "SPPlayerItemFilterDefine.h"

@class SPHero;

@interface SPPlayerItemFilterUnit : SPFilterUnit

@property (assign, nonatomic) BOOL isPlaceholder;
@property (assign, nonatomic) BOOL tradable;
@property (assign, nonatomic) BOOL marketable;

+ (instancetype)inputUnit;
+ (instancetype)unit:(SPPlayerItemFilterType)type
               title:(NSString *)title
              object:(NSString *)object;
+ (instancetype)heroUnit:(SPHero *)hero;
+ (instancetype)emptyHeroUnit;

+ (instancetype)tradableUnit:(BOOL)tradable;
+ (instancetype)marketableUnit:(BOOL)marketable;

- (SPPlayerItemFilterType)type;
- (void)updateHero:(SPHero *)hero;

@end
