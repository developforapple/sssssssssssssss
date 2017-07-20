//
//  SPItem+Cache.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItem.h"

typedef void(^SPItemCacheCompletion)(id content);

// 对饰品的图片地址和大图地址进行缓存
@interface SPItem (Cache)

// 存储在七牛的图片url
- (NSURL *)qiniuSmallURL;
- (NSURL *)qiniuLargeURL;

// 获取饰品小图。如果缓存了，读取缓存。
- (void)getItemImageInventory:(SPItemCacheCompletion)completion;
// 获取饰品大图。如果缓存了，读取缓存
- (void)getItemImageInventoryLarge:(SPItemCacheCompletion)completion;
// 获取饰品banner。如果缓存了，读取缓存
- (void)getItemBanner:(SPItemCacheCompletion)comletion;

@end
