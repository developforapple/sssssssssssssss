//
//  SPDiskCacheControl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/23.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPDiskCacheControl.h"
#import "SPWorkshopModel.h"
@import YYCache;

@implementation SPDiskCacheControl

#pragma mark - Folder
+ (NSString *)imageCacheFolder
{
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"com.wwwbbat.Dota2.imageCache"];
        folder = cachePath;
    });
    return folder;
}

+ (NSString *)dataCacheFolder
{
    static NSString *folder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"com.wwwbbat.Dota2.dataCache"];
        folder = cachePath;
    });
    return folder;
}

#pragma mark - Workshop
+ (SDImageCache *)workshopImageCache
{
    static SDImageCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [[self imageCacheFolder] stringByAppendingPathComponent:@"workshop"];
        cache = [[SDImageCache alloc] initWithNamespace:@"workshop" diskCacheDirectory:cachePath];
    });
    return cache;
}

+ (SDWebImageManager *)workshopImageManager
{
    static SDWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        if ([queue respondsToSelector:@selector(setQualityOfService:)]) {
            queue.qualityOfService = NSQualityOfServiceBackground;
        }
        manager = [[SDWebImageManager alloc] initWithCache:[self workshopImageCache] downloader:[SDWebImageDownloader sharedDownloader]];
        [manager setCacheKeyFilter:^NSString *(NSURL *URL) {
            return [SPWorkshopResource cacheKeyOfURL:URL];
        }];
    });
    return manager;
}

+ (YYCache *)workshopDataCache
{
    static YYCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [[self dataCacheFolder] stringByAppendingPathComponent:@"workshop"];
        cache = [YYCache cacheWithPath:cachePath];
    });
    return cache;
}

+ (void)cleanWorkshopImageCache:(SPProgress)progress end:(SPEndBlock)endblock;
{
    [[self workshopImageCache] clearDiskOnCompletion:^{
        
        endblock?endblock(YES):0;
    }];
}

+ (void)cleanWorkshopDataCache:(SPProgress)progress end:(SPEndBlock)endblock;
{
    [[[self workshopDataCache] diskCache] removeAllObjectsWithProgressBlock:progress endBlock:endblock];
}

+ (void)workshopImageCacheCost:(SPCompletion)completion
{
    [[self workshopImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        completion?completion(totalSize):0;
    }];
}

+ (void)workshopDataCacheCost:(SPCompletion)completion
{
    [[[self workshopDataCache] diskCache] totalCostWithBlock:completion];
}

+ (void)itemImageCacheCost:(SPCompletion)completion
{
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        completion?completion(totalSize):0;
    }];
}

+ (void)cleanItemImageCache:(SPProgress)progress end:(SPEndBlock)endblock
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        endblock?endblock(YES):0;
    }];
}

@end
