//
//  SPItemImageLoader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemImageLoader.h"
@import YYCache;
#import "SPMemoryCache.h"
#import "CALayer+SDWebCache.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

YYCache *
normalImageCache(){
    static YYCache *_kDefaultCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [AppDocumentsPath stringByAppendingPathComponent:@".itemImageCache.small"];
        _kDefaultCache = [[YYCache alloc] initWithPath:path];
    });
    return _kDefaultCache;
}

YYCache *
largeImageCache(){
    static YYCache *_kDefaultCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [AppDocumentsPath stringByAppendingPathComponent:@".itemImageCache.large"];
        _kDefaultCache = [[YYCache alloc] initWithPath:path];
    });
    return _kDefaultCache;
}

YYCache *
cacheForImageType(SPImageType type){
    YYCache *cache;
    switch (type) {
        case SPImageTypeNormal: cache = normalImageCache(); break;
        case SPImageTypeLarge:  cache = largeImageCache();  break;
        case SPImageTypeIngame: break;
    }
    return cache;
}

YYCache *
qiniuCache(){
    static YYCache *_kQiniuUnuploadItemsCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [AppDocumentsPath stringByAppendingPathComponent:@".QiniuItemCache.cache"];
        _kQiniuUnuploadItemsCache = [[YYCache alloc] initWithPath:path];
        
        // 上传没有图片的token记录
        // TODO
        
        
    });
    return _kQiniuUnuploadItemsCache;
}

UIImage *
placeholderImage(CGSize size){
    
    if (CGSizeEqualToSize(size, kNonePlaceholderSize))  return nil;
    
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYMemoryCache alloc] init];
        cache.autoTrimInterval = CGFLOAT_MAX;
    });

    NSNumber *k = @( ((int)size.width) << 12 | ((int)size.height) );
    UIImage *image = [cache objectForKey:k];
    if (image) return image;

    image = [[UIImage imageNamed:@"placeholder"] imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
    NSData *data = [image sd_imageDataAsFormat:SDImageFormatWebP];
    image = [UIImage sd_imageWithData:data];
    [cache setObject:image forKey:k];
    return image;
}

dispatch_queue_t
resizeImageQueue(void){
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("SPResizeImageQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

CGSize const kNonePlaceholderSize = {-1,-1};

@implementation SPItemImageLoader

+ (void)setSDWebImageUseYYMemoryCache
{
    // SDWebImage的imageCache存在一个 memCache 的属性作为内存缓存 其类型为 NSCache
    // SPMemoryCache 继承 YYMemoryCache 兼容了 NSCache 的接口
    SPMemoryCache *cache = [[SPMemoryCache alloc] init];
    NSString *k = @"memCache";
    SEL memCacheGetter = NSSelectorFromString(k);
    if ([[SDWebImageManager sharedManager].imageCache respondsToSelector:memCacheGetter]) {
        NSCache *sdMemCache = [[SDWebImageManager sharedManager].imageCache valueForKey:k];
        cache.name = sdMemCache.name;
        [[SDWebImageManager sharedManager].imageCache setValue:cache forKey:k];
        [sdMemCache removeAllObjects];
    }
}

+ (void)getItemImageURL:(SPItem *)item
                 ofType:(SPImageType)type
             completion:(SPItemCacheCompletion)completion
{
    NSString *name = [item itemImageIconName];
    NSString *url = (NSString *)[cacheForImageType(type) objectForKey:name];
    if (url.length) {
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
            [cacheForImageType(type) setObject:url forKey:name];
            completion(url);
        }else{
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        completion(nil);
    }];
}

+ (void)loadImageURL:(NSURL *)URL
                size:(CGSize)size
           imageView:(UIImageView *)imageView
              failed:(void(^)(NSError *))failed
{
    NSUInteger hash = URL.hash;
    ygweakify(imageView);
    [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage(size) options:SDWebImageContinueInBackground | SDWebImageLowPriority | SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSUInteger hash2 = hash;
        if (hash2 == imageURL.hash) {
            if (image) {
                ygstrongify(imageView);
                imageView.hidden = NO;
                return;
            }
            failed ? failed(error) : 0;
        }
    }];;
}

+ (void)loadImageURL:(NSURL *)URL
                size:(CGSize)size
               layer:(CALayer *)layer
              failed:(void(^)(NSError *))failed
{
    NSInteger hash = URL.hash;
    
    ygweakify(layer);
    [layer sd_setImageWithURL:URL placeholderImage:placeholderImage(size) options:SDWebImageContinueInBackground | SDWebImageLowPriority | SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSInteger hash2 = hash;
        if (hash2 == imageURL.hash) {
            if (image) {
                ygstrongify(layer);
                layer.hidden = NO;
                return;
            }
            failed ? failed(error) : 0;
        }
    }];
}

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
            imageView:(UIImageView *)imageView
{
    NSURL *qiniuURL = [item qiniuURLOfType:type];
    [self loadImageURL:qiniuURL size:size imageView:imageView failed:^(NSError *err) {
        
        //        [qiniuCache() setObject:@YES forKey:item.token.description];
        
        // 加载原始图片
        [self getItemImageURL:item ofType:type completion:^(id content) {
            
            if (content) {
                
                [self loadImageURL:content size:size imageView:imageView failed:nil];
                
            }else if(type == SPImageTypeLarge){
                
                // 获取原始大图出错时，显示原始小图
                [self loadItemImage:item size:size type:SPImageTypeNormal imageView:imageView];
                
            }
        }];
    }];
}

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
                layer:(CALayer *)layer
{
    NSURL *qiniuURL = [item qiniuURLOfType:type];
    [self loadImageURL:qiniuURL size:size layer:layer failed:^(NSError *err) {
        
        //        [qiniuCache() setObject:@YES forKey:item.token.description];
        
        // 加载原始图片
        [self getItemImageURL:item ofType:type completion:^(id content) {
            
            if (content) {
                
                [self loadImageURL:content size:size layer:layer failed:nil];
                
            }else if(type == SPImageTypeLarge){
                
                // 获取原始大图出错时，显示原始小图
                [self loadItemImage:item size:size type:SPImageTypeNormal layer:layer];
                
            }
        }];
    }];
}

+ (void)prefetchItemImages:(NSArray *)itemImages
{
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:itemImages];
}

+ (void)clearMemory
{
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end

@implementation SPItem (ImageURL)

- (NSString *)itemImageIconName
{
    NSString *fullName = self.image_inventory;
    NSString *name = [[fullName lastPathComponent] lowercaseString];
    return name;
}

- (NSURL *)qiniuSmallURL
{
    NSString *URLString = [self qiniuImageURLString];
    NSString *smallURLString = [[URLString stringByAppendingString:@"/small"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return smallURLString ? [NSURL URLWithString:smallURLString] : nil;
}

- (NSURL *)qiniuLargeURL
{
    NSString *URLString = [self qiniuImageURLString];
    NSString *largeURLString = [[URLString stringByAppendingString:@"/large"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return largeURLString ? [NSURL URLWithString:largeURLString] : nil;
}

- (NSString *)qiniuImageURLString
{
    if (self.image_inventory.length == 0) return nil;
    NSString *name = [[self.image_inventory lowercaseString] stringByReplacingOccurrencesOfString:@"/" withString:@"%%2F"];
    NSString *urlString = [NSString stringWithFormat:@"http://items-3-0.qiniudn.com/%@",name];
    return urlString;
}

- (NSURL *)qiniuURLOfType:(SPImageType)type
{
    NSURL *qiniuURL;
    switch (type) {
        case SPImageTypeNormal: qiniuURL = [self qiniuSmallURL]; break;
        case SPImageTypeLarge:  qiniuURL = [self qiniuLargeURL]; break;
        case SPImageTypeIngame: break;
    }
    return qiniuURL;
}

@end
