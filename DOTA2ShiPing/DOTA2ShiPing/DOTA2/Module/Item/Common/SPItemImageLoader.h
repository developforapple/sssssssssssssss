//
//  SPItemImageLoader.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPItem.h"

@class YYCache;

typedef NS_ENUM(NSUInteger, SPImageType) {
    SPImageTypeNormal,
    SPImageTypeLarge,
    SPImageTypeIngame,
};

typedef void(^SPItemCacheCompletion)(NSString *urlString);

YG_EXTERN YYCache *normalImageCache();
YG_EXTERN YYCache *largeImageCache();
YG_EXTERN YYCache *qiniuCache();
YG_EXTERN YYCache *cacheForImageType(SPImageType type);
YG_EXTERN UIImage *placeholderImage(CGSize size);

@interface SPItemImageLoader : NSObject

+ (void)setSDWebImageUseYYMemoryCache;

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
            imageView:(UIImageView *)imageView;

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
                layer:(CALayer *)layer;

+ (void)prefetchItemImages:(NSArray<NSString *> *)itemImages;

+ (void)clearMemory;

@end


@interface SPItem (ImageURL)
- (NSString *)itemImageIconName;
- (NSString *)qiniuImageURLString;
- (NSURL *)qiniuSmallURL;
- (NSURL *)qiniuLargeURL;
- (NSURL *)qiniuURLOfType:(SPImageType)type;
@end
