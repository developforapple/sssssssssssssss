//
//  SPBaseFilter.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBaseFilter.h"
#import "SPFilterViewCtrl.h"
#import "SPFilterUnit.h"

@implementation SPBaseFilter

- (instancetype)init
{
    SPFilterConfig *config = [SPFilterConfig defaultConfig];
    return [self initWithConfig:config];
}

- (instancetype)initWithConfig:(SPFilterConfig *)config
{
    self = [super init];
    if (self) {
        _config = config;
    }
    return self;
}

- (void)didChangedInputText:(NSString *)text toUnit:(SPFilterUnit *)unit atGroup:(SPFilterGroup *)group
{
    
}

- (void)didSelectedUnit:(SPFilterUnit *)unit atGroup:(SPFilterGroup *)group
{
    
}

- (void)didDeselectedUnit:(SPFilterUnit *)unit atGroup:(SPFilterGroup *)group
{
    
}

- (SPFilterGroup *)groupOfUnit:(SPFilterUnit *)unit
{
    if (!unit) return nil;
    for (SPFilterGroup *aGroup in self.groups) {
        if ([aGroup.units containsObject:unit]) {
            return aGroup;
        }
    }
    return nil;
}

- (void)updateGroup:(SPFilterGroup *)group
{
    NSInteger section = [self.groups indexOfObject:group];
    if (section != NSNotFound) {
        [[self.filterViewCtrl collectionView] reloadSections:[NSIndexSet indexSetWithIndex:section]];
    }
}

- (void)appendUnit:(SPFilterUnit *)unit toGroup:(SPFilterGroup *)group
{
    [self insertUnit:unit toGroup:group atIndex:group.units.count];
}

- (void)insertUnit:(SPFilterUnit *)unit toGroup:(SPFilterGroup *)group atIndex:(NSInteger)index
{
    [group insertUnit:unit atIndex:index];
    NSInteger section = [self.groups indexOfObject:group];
    [[self.filterViewCtrl collectionView] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:section]]];
}

- (void)removeUnit:(SPFilterUnit *)unit
{
    SPFilterGroup *group = [self groupOfUnit:unit];
    if (group){
        NSInteger section = [self.groups indexOfObject:group];
        NSInteger item = [group.units indexOfObject:unit];
        [group removeUnit:unit];
        [[self.filterViewCtrl collectionView] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:item inSection:section]]];
    }
}

- (void)moveUnit:(SPFilterUnit *)unit toIndex:(NSInteger)index
{
    SPFilterGroup *group = [self groupOfUnit:unit];
    if (group) {
        NSInteger section = [self.groups indexOfObject:group];
        NSInteger item = [group.units indexOfObject:unit];
        [group moveUnit:unit toIndex:index];
        [[self.filterViewCtrl collectionView] moveItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]
                                                      toIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
        
    }
}

- (void)selectUnit:(SPFilterUnit *)unit
{
    SPFilterGroup *group = [self groupOfUnit:unit];
    if (group) {
        NSInteger section = [self.groups indexOfObject:group];
        NSInteger item = [group.units indexOfObject:unit];
        [[self.filterViewCtrl collectionView] selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)deselectUnit:(SPFilterUnit *)unit
{
    SPFilterGroup *group = [self groupOfUnit:unit];
    if (group) {
        NSInteger section = [self.groups indexOfObject:group];
        NSInteger item = [group.units indexOfObject:unit];
        [[self.filterViewCtrl collectionView] deselectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section] animated:YES];
    }
}

- (NSArray<SPFilterUnit *> *)unitsOfKind:(SPFilterKind)kind
{
    NSMutableArray *array = [NSMutableArray array];
    for (SPFilterGroup *group in self.groups) {
        for (SPFilterUnit *unit in group.units) {
            if (unit.kind == kind) {
                [array addObject:unit];
            }
        }
    }
    return array;
}

@end
