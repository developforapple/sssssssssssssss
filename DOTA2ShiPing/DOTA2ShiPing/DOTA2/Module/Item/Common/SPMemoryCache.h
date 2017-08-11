//
//  SPMemoryCache.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/11.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YYMemoryCache.h"

NS_ASSUME_NONNULL_BEGIN


/**
 模仿NSCache的公开接口，实际上却是YYMemoryCache
 */
@interface SPMemoryCache <KeyType, ObjectType> : YYMemoryCache

// 父类
//@property (copy) NSString *name;

// 无用
@property (nullable, assign) id<NSCacheDelegate> delegate;

// 父类
- (nullable ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key; // 0 cost
- (void)setObject:(nullable ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;
- (void)removeObjectForKey:(KeyType)key;

- (void)removeAllObjects;

@property NSUInteger totalCostLimit;
//@property NSUInteger countLimit;
@property BOOL evictsObjectsWithDiscardedContent;

@end

NS_ASSUME_NONNULL_END
