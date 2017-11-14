//
//  SPFilterOption.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SPFilterOptionType) {
    SPFilterOptionTypeText = 1 << 0,
    SPFilterOptionTypeHero = 1 << 1,
    SPFilterOptionTypeRarity = 1 << 2,
    SPFilterOptionTypeEvent = 1 << 3,
};
#define SPFilterOptionTypeAll ( SPFilterOptionTypeText | \
                                SPFilterOptionTypeHero | \
                                SPFilterOptionTypeRarity | \
                                SPFilterOptionTypeEvent)

@class SPFilterOption;
@class SPItemRarity;
@class SPHero;
@class SPDotaEvent;

@interface SPFilterOptionGroup : NSObject
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) SPFilterOptionType type;
@property (strong, nonatomic) NSArray<SPFilterOption *> *options;

+ (instancetype)textGroup;
+ (instancetype)rarityGroup:(NSArray<SPItemRarity *> *)rarities;
+ (instancetype)eventGroup:(NSArray<SPDotaEvent *> *)events;
+ (instancetype)heroGroup:(SPFilterOption *)option;

@end

@interface SPFilterOption : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) SPFilterOptionType type;
@property (strong, nonatomic) id option;

+ (instancetype)textOption;
+ (instancetype)rarityOption:(SPItemRarity *)rarity;
+ (instancetype)heroOption:(SPHero *)hero;
+ (instancetype)emptyHeroOption;
+ (instancetype)eventOption:(SPDotaEvent *)event;

- (void)updateHero:(SPHero *)hero;

@end
