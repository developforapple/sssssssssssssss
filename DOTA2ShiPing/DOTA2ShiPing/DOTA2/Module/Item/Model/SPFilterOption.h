//
//  SPFilterOption.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SPFilterOptionType) {
    SPFilterOptionTypeHero = 1 << 0,
    SPFilterOptionTypeRarity = 1 << 1,
    SPFilterOptionTypeEvent = 1 << 2,
};

@class SPFilterOption;
@class SPItemRarity;
@class SPHero;
@class SPDotaEvent;

@interface SPFilterOptionGroup : NSObject
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) SPFilterOptionType type;
@property (strong, nonatomic) NSArray<SPFilterOption *> *options;

+ (instancetype)rarityGroup:(NSArray<SPItemRarity *> *)rarities;
+ (instancetype)eventGroup:(NSArray<SPDotaEvent *> *)events;
+ (instancetype)heroGroup:(SPFilterOption *)option;

@end

@interface SPFilterOption : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) SPFilterOptionType type;
@property (strong, nonatomic) id option;

+ (instancetype)rarityOption:(SPItemRarity *)rarity;
+ (instancetype)heroOption:(SPHero *)hero;
+ (instancetype)emptyHeroOption;
+ (instancetype)eventOption:(SPDotaEvent *)event;

- (void)updateHero:(SPHero *)hero;

@end
