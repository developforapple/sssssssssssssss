//
//  SPItemImageLoader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemImageLoader.h"
#import "YYCache.h"

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
placeholderImage(){
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"HeroPlacehodler"];
    });
    return img;
}

@implementation SPItemImageLoader

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
           imageView:(UIImageView *)imageView
              failed:(void(^)(NSError *))failed
{
    NSUInteger hash = URL.hash;
    ygweakify(imageView);
    [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage() options:SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSUInteger hash2 = hash;
        if (hash2 == imageURL.hash) {
            if (!error && image) {
                ygstrongify(imageView);
                imageView.image = image;
                return;
            }
            failed ? failed(error) : 0;
        }
    }];;
}

+ (void)loadItemImage:(SPItem *)item
                 type:(SPImageType)type
            imageView:(UIImageView *)imageView
{
    NSURL *qiniuURL = [item qiniuURLOfType:type];
    [self loadImageURL:qiniuURL imageView:imageView failed:^(NSError *err) {
        
        [qiniuCache() setObject:@YES forKey:item.token.description];
        
        // 加载原始图片
        [self getItemImageURL:item ofType:type completion:^(id content) {
            
            if (content) {
                
                [self loadImageURL:content imageView:imageView failed:nil];
                
            }else if(type == SPImageTypeLarge){
                
                // 获取原始大图出错时，显示原始小图
                [self loadItemImage:item type:SPImageTypeNormal imageView:imageView];
            
            }
        }];
    }];
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
