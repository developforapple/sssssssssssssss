//
//  SPDiskCacheControl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/23.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYWebImage.h>

typedef void (^SPCompletion)(NSInteger cost);
typedef void (^SPProgress)(int removed,int total);
typedef void (^SPEndBlock)(BOOL suc);

@interface SPDiskCacheControl : NSObject

#pragma mark - Workshop
+ (YYImageCache *)workshopImageCache;
+ (YYWebImageManager *)workshopImageManager;
+ (YYCache *)workshopDataCache;

+ (void)cleanWorkshopImageCache:(SPProgress)progress end:(SPEndBlock)endblock;
+ (void)cleanWorkshopDataCache:(SPProgress)progress end:(SPEndBlock)endblock;

+ (void)workshopImageCacheCost:(SPCompletion)completion;
+ (void)workshopDataCacheCost:(SPCompletion)completion;

#pragma mark - Other
+ (void)itemImageCacheCost:(SPCompletion)completion;
+ (void)cleanItemImageCache:(SPProgress)progress end:(SPEndBlock)endblock;

@end
