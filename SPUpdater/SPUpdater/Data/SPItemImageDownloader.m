//
//  SPItemImageDownloader.m
//  ShiPing
//
//  Created by wwwbbat on 2017/7/17.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemImageDownloader.h"
#import <FMDatabase.h>
#import "SPLogHelper.h"
//#import <AssetsLibrary/AssetsLibrary.h>

@import AppKit;
#import "SPPathManager.h"

NSData *UIImageJPEGRepresentation(NSImage *image,float quality){
    NSData *data = [image TIFFRepresentation];
    NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:data];
    [rep setSize:image.size];
    NSData *jpegData = [rep representationUsingType:NSJPEGFileType properties:@{NSImageCompressionFactor:@(0.85)}];
    return jpegData;
}

#define FileManager [NSFileManager defaultManager]

static NSString *getQiniuName(NSString *inventory){
    return [NSString stringWithFormat:@"%lu",(unsigned long)[[inventory stringByAppendingString:@"_0123456789"] hash]];
}

@implementation SPItemImageDownloader


+ (NSString *)normalPath
{
    NSString *path = [[SPPathManager imagePath] stringByAppendingPathComponent:@"normal"];
    [SPPathManager createFolderIfNeed:path];
    return path;
}

+ (NSString *)largePath
{
    NSString *path = [[SPPathManager imagePath] stringByAppendingPathComponent:@"large"];
    [SPPathManager createFolderIfNeed:path];
    return path;
}

+ (NSDictionary *)itemImageMap:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    FMResultSet *result = [db executeQuery:@"SELECT token,image_inventory FROM items"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while ([result next]) {
        NSString *token = [result stringForColumn:@"token"];
        NSString *image_inventory = [result stringForColumn:@"image_inventory"];
        dict[token] = image_inventory;
    }
    [result close];
    [db close];
    return dict;
}

+ (void)compressImages
{
    NSString *imageFolder = [self largePath];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:imageFolder];
    
    long long pre = 0;
    long long cur = 0;
    
    for (NSString *aFile in files) {
        
        if ([aFile isEqualToString:@".DS_Store"]) {
            continue;
        }
        
        BOOL directory = NO;
        NSString *path = [imageFolder stringByAppendingPathComponent:aFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory] && !directory) {
            
            NSNumber *size = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil][NSFileSize];
            long preSize = size.longValue;
            
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            NSData *data = UIImageJPEGRepresentation(image, 0.90);
            
            long curSize = data.length;
            
            SPLog(@"原始大小: %d kb",(int)preSize/1024);
            SPLog(@"压缩后大小：%d kb",(int)curSize/1024);
            SPLog(@"压缩率：%.1f%%",curSize/(float)preSize*100);
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [data writeToFile:path atomically:YES];
            
            pre += preSize;
            cur += curSize;
        }
    }
    
    SPLog(@"压缩前：%d Mb", (int)pre / 1024 / 1024);
    SPLog(@"压缩后：%d Mb", (int)cur / 1024 / 1024);
    SPLog(@"总压缩率： %.1f %%",cur/(double)pre * 100);
    
    SPLog(@"Done");
}

+ (void)download:(NSString *)dbPath
{
    SPLog(@"下载图片！");
    
    SPLog(@"读取数据库");
    NSDictionary *map = [self itemImageMap:dbPath];
    SPLog(@"共找到 %d 个饰品",(int)map.count);
    
    NSArray *allKeys = [map allKeys];
    NSInteger count = allKeys.count;
    
    NSInteger idx = 0;
    NSInteger length = 0;
    
    while (idx < count) {
        
        length = (idx+2000) < count ? 2000 : (count-idx) ;
        
        NSArray *subKeys = [allKeys subarrayWithRange:NSMakeRange(idx, length)];
        NSArray *subValues = [map objectsForKeys:subKeys notFoundMarker:@""];
        
        NSDictionary *subDict = [NSDictionary dictionaryWithObjects:subValues forKeys:subKeys];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadThread:subDict identifier:[NSString stringWithFormat:@"%d-%d",(int)idx,(int)(idx+2000)]];
        });
        
        idx += length;
    }
}

+ (void)downloadThread:(NSDictionary *)map identifier:(NSString *)identifier
{
    //    NSString *normalDonePath = [[self root] stringByAppendingPathComponent:[NSString stringWithFormat:@"normalDone_%@",identifier]];
    NSString *largeDonePath = [[SPPathManager imagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"largeDone_%@",identifier]];
    //    NSMutableArray *normalDone = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:normalDonePath]];
    NSMutableArray *largeDone = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:largeDonePath]];
    
    //    SPLog(@"本轮下载开始，还有 %d 个小图未完成",(map.count-normalDone.count));
    SPLog(@"%@，还有 %d 个大图未完成",identifier,(int)(map.count-largeDone.count));
    
    //    NSString *normalFolder = [self normalPath];
    NSString *largeFolder = [[self largePath] stringByAppendingPathComponent:identifier];
    [SPPathManager createFolderIfNeed:largeFolder];
    
    for (NSString *token in map) {
        
        //        BOOL hasNormalImage = [normalDone containsObject:token];
        BOOL hasLargeImage = [largeDone containsObject:token];
        
        if ( hasLargeImage) {
            continue;
        }
        
        NSString *imageInventory = map[token];
        
        
        // 旧的命名方式
        // NSString *qiniuName = [imageInventory stringByReplacingOccurrencesOfString:@"/" withString:@"%%2F"];
        // 新的命名方式
        NSString *qiniuName = getQiniuName(imageInventory);

        NSString *name = [[imageInventory lastPathComponent] lowercaseString];
        
        //        NSString *normalPath = [normalFolder stringByAppendingPathComponent:qiniuName];
        NSString *largePath = [largeFolder stringByAppendingPathComponent:qiniuName];
    
        if ([[NSFileManager defaultManager] fileExistsAtPath:largePath]) {
            [largeDone addObject:token];
            continue;
        }
        
        //        int normalDownloadResult = [self downloadImageNamed:name type:0 toPath:normalPath];
        int largeDownloadResult = [self downloadImageNamed:name type:1 toPath:largePath];
        
        //        if (normalDownloadResult) {
        //            [normalDone addObject:token];
        //
        //            SPLog(@"小图进度： %d / %d",normalDone.count,map.count);
        //        }
        if (largeDownloadResult) {
            [largeDone addObject:token];
            
            SPLog(@"\t%@ ： %d / %d",identifier,(int)largeDone.count,(int)map.count);
        }
    }
    
    //    [FileManager removeItemAtPath:normalDonePath error:nil];
    [FileManager removeItemAtPath:largeDonePath error:nil];
    //    [normalDone writeToFile:normalDonePath atomically:YES];
    [largeDone writeToFile:largeDonePath atomically:YES];
    
    //    SPLog(@"本轮下载结束，还有 %d 个小图未完成",(map.count-normalDone.count));
    SPLog(@"\t%@结束，还有 %d 个大图未完成",identifier,(int)(map.count-largeDone.count));
}


/**
 下载图片

 @param name 图片名
 @param type 0小图 1大图 2ingame
 @param path 保存位置
 @return 0：错误 1：成功 2：不需要下载
 */
+ (int)downloadImageNamed:(NSString *)name type:(int)type toPath:(NSString *)path
{
    if (name.length == 0) {
        return 2;
    }
    
    NSString *imageURL;
    
    // 获取图片链接
    {
        NSString *key = arc4random_uniform(10)%2==0?@"CD9010FD71FA1583192F9BDB87ED8164":@"D46675A241E560655ABD306C2A275D60";
        NSString *URL = [@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1?" stringByAppendingFormat:@"key=%@&iconname=%@&icontype=%d",key,name,type];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL] options:NSDataReadingUncached error:&error];
        if (error || !data) {
            if (type == 1) {
                // 大图没找到，下载小图
                [self downloadImageNamed:name type:0 toPath:path];
                return 0;
            }
            SPLog(@"data出错了！%@",error);
            return 0;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            if (type == 1) {
                // 大图没找到，下载小图
                [self downloadImageNamed:name type:0 toPath:path];
                return 0;
            }
            SPLog(@"dict出错了！");
            return 0;
        }
        NSString *imageRemotePath = dict[@"result"][@"path"];
        if (imageRemotePath.length == 0) {
            if (type == 1) {
                // 大图没找到，下载小图
                [self downloadImageNamed:name type:0 toPath:path];
                return 0;
            }
            return 0;
        }
        
        imageURL = [@"http://cdn.dota2.com/apps/570/" stringByAppendingString:imageRemotePath];
    }
    
    // 下载图片
    {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL] options:NSDataReadingUncached error:&error];
        if (error || !data) {
            SPLog(@"下载图片出错了！%@",error);
            return 0;
        }
        [FileManager removeItemAtPath:path error:nil];
        
        NSImage *image = [[NSImage alloc] initWithData:data];
        NSData *jpegData = UIImageJPEGRepresentation(image, 0.90);
        [jpegData writeToFile:path atomically:YES];
    }
    return 1;
}

@end
