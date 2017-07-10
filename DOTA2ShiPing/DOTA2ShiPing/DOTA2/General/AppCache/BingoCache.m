//
//  BingoCache.m
//
//  Created by WangBo on 2017/4/10.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "BingoCache.h"

@interface BingoCache ()
@end

@implementation BingoCache
+ (instancetype)appCache;
{
    return [self cache:nil];
}

+ (instancetype)cache:(NSString *)uid
{
    static NSMutableDictionary<NSString *,BingoCache *> *dict;
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSString *key = uid?:@"universal";
    BingoCache *cache = dict[key];
    if (!cache) {
        cache = [[BingoCache alloc] initWithName:[NSString stringWithFormat:@"com.jsbingo.app.cacheContainer.%@",key]];
        dict[key] = cache;
    }
    dispatch_semaphore_signal(semaphore);
    return cache;
}

@end
