//
//  SPItemFilter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemFilter.h"
#import "SPItemFilterGroup.h"
#import "SPItemFilterUnit.h"
#import "SPDataManager.h"

#import "SPItemHeroPickerVC.h"
#import "SPFilterViewCtrl.h"

@interface SPItemFilter ()
@property (assign, readwrite, nonatomic) SPItemFilterType types;
@end

@implementation SPItemFilter

- (id<SPItemFilterDelegate>)delegate
{
    return (id<SPItemFilterDelegate>)[super delegate];
}

- (void)setupTypes:(SPItemFilterType)types
{
    _types = types;
    
    NSMutableArray *groups = [NSMutableArray array];
    if (types & SPItemFilterTypeInput) {
        [groups addObject:[SPItemFilterGroup itemInputGroup]];
    }
    if (types & SPItemFilterTypeHero) {
        [groups addObject:[SPItemFilterGroup itemHeroGroup:[SPItemFilterUnit itemEmptyHeroUnit]]];
    }
    if (types & SPItemFilterTypeRarity) {
        [groups addObject:[SPItemFilterGroup itemRarityGroup:[SPDataManager shared].rarities]];
    }
    if (types & SPItemFilterTypeEvent) {
        [groups addObject:[SPItemFilterGroup itemEventGroup:[SPDataManager shared].events]];
    }
    self.groups = groups;
}

- (void)didChangedInputText:(NSString *)text toUnit:(SPItemFilterUnit *)unit atGroup:(SPItemFilterGroup *)group
{
    
}

- (void)didSelectedUnit:(SPItemFilterUnit *)unit atGroup:(SPItemFilterGroup *)group
{
    if ([unit type] == SPItemFilterTypeHero) {
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

- (void)didDeselectedUnit:(SPItemFilterUnit *)unit atGroup:(SPItemFilterGroup *)group
{
    if ([unit type] == SPItemFilterTypeHero) {
        if (!(self.config.allowsMultipleSelection && self.config.allowsMultipleSelectionInSection)) {
            [unit itemUpdateHero:nil];
            [self updateGroup:group];
        }
    }
}

- (SPItemFilterGroup *)heroGroup
{
    for (SPItemFilterGroup *aGroup in self.groups) {
        if ([aGroup type] == SPItemFilterTypeHero) {
            return aGroup;
        }
    }
    return nil;
}

- (SPFilterUnit *)heroUnitIfExist:(SPHero *)hero
{
    SPItemFilterGroup *group = [self heroGroup];
    for (SPItemFilterUnit *unit in group.units) {
        SPHero *aHero = unit.object;
        if ([aHero.HeroID isEqualToString:hero.HeroID]) {
            return unit;
        }
    }
    return nil;
}

- (void)selectHero:(SPHero *)hero
{
    SPItemFilterGroup *group = [self heroGroup];
    
    if (self.config.allowsMultipleSelection && self.config.allowsMultipleSelectionInSection) {
        //可选多个
        
        SPFilterUnit *unit = [self heroUnitIfExist:hero];
        if (unit) {
            [self moveUnit:unit toIndex:0];
        }else{
            unit = [SPItemFilterUnit itemHeroUnit:hero];
            [self insertUnit:unit toGroup:group atIndex:group.units.count-1];
        }
        [self selectUnit:unit];
    }else{
        //只选一个
        SPItemFilterUnit *unit = (SPItemFilterUnit *)group.units.firstObject;
        [unit itemUpdateHero:hero];
        [self updateGroup:group];
    }
}

@end
