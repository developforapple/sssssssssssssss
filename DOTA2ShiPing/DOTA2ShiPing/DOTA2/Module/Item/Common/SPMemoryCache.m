//
//  SPMemoryCache.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/11.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPMemoryCache.h"

@implementation SPMemoryCache

- (nullable id)objectForKey:(id)key
{
    return [super objectForKey:key];
}

- (void)setObject:(nullable id)obj forKey:(id)key // 0 cost
{
    [super setObject:obj forKey:key];
}

- (void)setObject:(nullable id)obj forKey:(id)key cost:(NSUInteger)g
{
    [super setObject:obj forKey:key withCost:g];
}

- (void)removeObjectForKey:(id)key
{
    [super removeObjectForKey:key];
}

- (void)removeAllObjects
{
    [super removeAllObjects];
}

- (void)setTotalCostLimit:(NSUInteger)totalCostLimit
{
    self.costLimit = totalCostLimit;
}

- (NSUInteger)totalCostLimit
{
    return self.costLimit;
}

@end
