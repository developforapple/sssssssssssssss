//
//  BingoCache.h
//
//  Created by WangBo on 2017/4/10.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import <YYCache/YYCache.h>

#define APPCACHE        [BingoCache appCache]
#define USERCACHE(uid)  [BingoCache cache:uid]

@interface BingoCache : YYCache

// 通用缓存
+ (instancetype)appCache;
// 分uid缓存 uid为nil时为通用缓存
+ (instancetype)cache:(NSString *)uid;

@end
