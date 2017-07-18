//
//  SPItem+Cache.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItem+Cache.h"

#import "AFNetworking.h"
#import "YYCache.h"

typedef NS_ENUM(NSUInteger, SPImageType) {
    SPImageTypeNormal,
    SPImageTypeLarge,
    SPImageTypeIngame,
};

@implementation SPItem (Cache)

- (YYCache *)cache
{
    static YYCache *_kDefaultCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".itemImageCache.cache"];
        _kDefaultCache = [[YYCache alloc] initWithPath:path];
    });
    return _kDefaultCache;
}

- (YYCache *)qiniuCache
{
    static YYCache *_kQiniuUnuploadItemsCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".QiniuItemCache.cache"];
        _kQiniuUnuploadItemsCache = [[YYCache alloc] initWithPath:path];
        
        // 上传没有图片的token记录
        // TODO
        
        
    });
    return _kQiniuUnuploadItemsCache;
}

- (NSString *)imageIconName
{
    NSString *fullName = self.image_inventory;
    NSString *name = [[fullName lastPathComponent] lowercaseString];
    return name;
}

- (void)imageURLForType:(SPImageType)type completion:(SPItemCacheCompletion)completion
{
    NSString *name = [self imageIconName];
    
    NSString *url = (NSString *)[[self cache] objectForKey:name];
    if (url) {
        completion(url);
        return;
    }
    
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"key"] = SteamKey();
    paramters[@"iconname"] = name;
    paramters[@"icontype"] = @(type);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1" parameters:paramters progress:nil success:^(NSURLSessionDataTask *task, id  responseObject) {
        
        NSString *path = responseObject[@"result"][@"path"];
        if (path) {
            NSString *url = [@"http://cdn.dota2.com.cn/apps/570" stringByAppendingPathComponent:path];
            [[self cache] setObject:url forKey:name];
            completion(url);
        }else{
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        completion(nil);
    }];
}

- (NSURL *)qiniuSmallURL
{
    NSString *URLString = [self qiniuImageURLString];
    NSString *smallURLString = [[URLString stringByAppendingString:@"/small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return smallURLString ? [NSURL URLWithString:smallURLString] : nil;
}

- (NSURL *)quniuLargeURL
{
    NSString *URLString = [self qiniuImageURLString];
    NSString *largeURLString = [URLString stringByAppendingString:@"/large"];
    return largeURLString ? [NSURL URLWithString:largeURLString] : nil;
}

- (NSString *)qiniuImageURLString
{
    if (self.image_inventory.length == 0) return nil;
    NSString *name = [[self.image_inventory lowercaseString] stringByReplacingOccurrencesOfString:@"/" withString:@"%%2F"];
    NSString *urlString = [NSString stringWithFormat:@"http://items-3-0.qiniudn.com/%@",name];
    return urlString;
}

- (void)getItemImageInventory:(SPItemCacheCompletion)completion
{
    NSNumber *token = self.token;
    [[self qiniuCache] setObject:@YES forKey:token.description];
    
    if (!completion) {
        return;
    }
    [self imageURLForType:SPImageTypeNormal completion:completion];
}

// 获取饰品大图。如果缓存了，读取缓存
- (void)getItemImageInventoryLarge:(SPItemCacheCompletion)completion
{

}

// 获取饰品banner。如果缓存了，读取缓存
- (void)getItemBanner:(SPItemCacheCompletion)comletion
{
    
}

@end
