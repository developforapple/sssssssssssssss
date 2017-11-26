//
//  SPPlayerItemFilter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemFilter.h"
#import "SPPlayerItemFilterGroup.h"
#import "SPPlayerItemFilterUnit.h"
#import "SPItemHeroPickerVC.h"
#import "SPHero.h"

@interface SPPlayerItemFilter ()
@property (assign, readwrite, nonatomic) SPPlayerItemFilterType types;
@end

@implementation SPPlayerItemFilter

- (void)setupTypes:(SPPlayerItemFilterType)types
        sharedData:(SPPlayerItemSharedData *)sharedData
{
    _types = types;
    
    NSMutableArray *groups = [NSMutableArray array];
    if (types & SPPlayerItemFilterTypeInput) {
        [groups addObject:[SPPlayerItemFilterGroup inputGroup]];
    }
    if (types & SPPlayerItemFilterTypeHero) {
        [groups addObject:[SPPlayerItemFilterGroup heroGroup:[SPPlayerItemFilterUnit emptyHeroUnit]]];
    }
    if (types & SPPlayerItemFilterTypeQuality) {
        [groups addObject:[SPPlayerItemFilterGroup qualityGroup:sharedData.qualityTags]];
    }
    if (types & SPPlayerItemFilterTypeRarity) {
        [groups addObject:[SPPlayerItemFilterGroup rarityGroup:sharedData.rarityTags]];
    }
    if (types & SPPlayerItemFilterTypePrefab) {
        [groups addObject:[SPPlayerItemFilterGroup prefabGroup:sharedData.prefabTags]];
    }
    if (types & SPPlayerItemFilterTypeSlot) {
        [groups addObject:[SPPlayerItemFilterGroup slotGroup:sharedData.slotTags]];
    }
    if (types & SPPlayerItemFilterTypeTradable) {
        [groups addObject:[SPPlayerItemFilterGroup tradableGroup]];
    }
    if (types & SPPlayerItemFilterTypeMarketable) {
        [groups addObject:[SPPlayerItemFilterGroup marketableGroup]];
    }
    self.groups = groups;
}

- (void)didChangedInputText:(NSString *)text toUnit:(SPPlayerItemFilterUnit *)unit atGroup:(SPPlayerItemFilterGroup *)group
{
    
}

- (void)didSelectedUnit:(SPPlayerItemFilterUnit *)unit atGroup:(SPPlayerItemFilterGroup *)group
{
    if ([unit type] == SPPlayerItemFilterTypeHero) {
        if (unit.isPlaceholder) {
            ygweakify(self);
            
            [self deselectUnit:unit];
            
            [SPItemHeroPickerVC presentFrom:self.filterViewCtrl selectedCallback:^BOOL(SPHero *hero) {
                ygstrongify(self);
                [self selectHero:hero];
                return YES;
            }];
        }
    }
}

- (void)didDeselectedUnit:(SPPlayerItemFilterUnit *)unit atGroup:(SPPlayerItemFilterGroup *)group
{
    if ([unit type] == SPPlayerItemFilterTypeHero) {
        if (!(self.config.allowsMultipleSelection && self.config.allowsMultipleSelectionInSection)) {
            [unit updateHero:nil];
            [self updateGroup:group];
        }
    }
}

- (SPPlayerItemFilterGroup *)heroGroup
{
    for (SPPlayerItemFilterGroup *aGroup in self.groups) {
        if ([aGroup type] == SPPlayerItemFilterTypeHero) {
            return aGroup;
        }
    }
    return nil;
}

- (SPFilterUnit *)heroUnitIfExist:(SPHero *)hero
{
    SPPlayerItemFilterGroup *group = [self heroGroup];
    for (SPPlayerItemFilterUnit *unit in group.units) {
        SPHero *aHero = unit.object;
        if ([aHero.HeroID isEqualToString:hero.HeroID]) {
            return unit;
        }
    }
    return nil;
}

- (void)selectHero:(SPHero *)hero
{
    SPPlayerItemFilterGroup *group = [self heroGroup];
    
    if (self.config.allowsMultipleSelection && self.config.allowsMultipleSelectionInSection) {
        //可选多个
        
        SPFilterUnit *unit = [self heroUnitIfExist:hero];
        if (unit) {
            [self moveUnit:unit toIndex:0];
        }else{
            unit = [SPPlayerItemFilterUnit heroUnit:hero];
            [self insertUnit:unit toGroup:group atIndex:group.units.count-1];
        }
        [self selectUnit:unit];
    }else{
        //只选一个
        SPPlayerItemFilterUnit *unit = (SPPlayerItemFilterUnit *)group.units.firstObject;
        [unit updateHero:hero];
        [self updateGroup:group];
    }
}

@end
