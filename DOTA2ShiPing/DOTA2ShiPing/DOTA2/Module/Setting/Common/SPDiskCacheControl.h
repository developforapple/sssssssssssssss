//
//  SPDiskCacheControl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/23.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SDWebImageManager.h"

@class YYCache;

typedef void (^SPCompletion)(NSInteger cost);
typedef void (^SPProgress)(int removed,int total);
typedef void (^SPEndBlock)(BOOL suc);

@interface SPDiskCacheControl : SPObject

#pragma mark - Workshop
+ (SDImageCache *)workshopImageCache;
+ (SDWebImageManager *)workshopImageManager;
+ (YYCache *)workshopDataCache;

+ (void)cleanWorkshopImageCache:(SPProgress)progress end:(SPEndBlock)endblock;
+ (void)cleanWorkshopDataCache:(SPProgress)progress end:(SPEndBlock)endblock;

+ (void)workshopImageCacheCost:(SPCompletion)completion;
+ (void)workshopDataCacheCost:(SPCompletion)completion;

#pragma mark - Other
+ (void)itemImageCacheCost:(SPCompletion)completion;
+ (void)cleanItemImageCache:(SPProgress)progress end:(SPEndBlock)endblock;

@end
