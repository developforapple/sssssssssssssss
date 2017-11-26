//
//  SPFilterGroup.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterGroup.h"

@implementation SPFilterGroup

- (void)insertUnit:(SPFilterUnit *)unit atIndex:(NSInteger)index
{
    if (!unit) return;
    NSMutableArray *units = [NSMutableArray arrayWithArray:self.units];
    [units insertObject:unit atIndex:index];
    self.units = units;
}

- (void)addUnit:(SPFilterUnit *)unit
{
    if (!unit) return;
    NSMutableArray *units = [NSMutableArray arrayWithArray:self.units];
    [units addObject:unit];
    self.units = units;
}

- (void)removeUnit:(SPFilterUnit *)unit
{
    if (!unit) return;
    NSMutableArray *units = [NSMutableArray arrayWithArray:self.units];
    if ([units containsObject:unit]) {
        [units removeObject:unit];
    }
    self.units = units;
}

- (void)resetUnits:(NSArray *)units
{
    self.units = units;
}

- (void)moveUnit:(SPFilterUnit *)unit toIndex:(NSInteger)index
{
    if (!unit) return;
    
    NSMutableArray *units = [NSMutableArray arrayWithArray:self.units];
    [units removeObject:unit];
    [units insertObject:unit atIndex:index];
    self.units = units;
}

@end
