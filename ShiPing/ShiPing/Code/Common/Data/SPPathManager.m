//
//  SPPathManager.m
//  ShiPing
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPathManager.h"

#define FileManager [NSFileManager defaultManager]

@implementation SPPathManager

+ (void)createFolderIfNeed:(NSString *)path
{
    BOOL isDirectory = NO;
    BOOL exists = [FileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!exists) {
        [FileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else if(!isDirectory){
        [FileManager removeItemAtPath:path error:nil];
        [FileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString *)rootPath
{
    NSString *path = @"~/Desktop/DOTA.tmp";
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)downloadPath
{
//    @"~/Desktop/DOTA.tmp/download"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"download"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)imagePath
{
//    @"~/Desktop/DOTA.tmp/image"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"image"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)baseDataPath
{
//    @"~/Desktop/DOTA.tmp/basedata"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"basedata"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langRoot
{
//    @"~/Desktop/DOTA.tmp/lang"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"lang"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langPath:(NSString *)lang
{
//    @"~/Desktop/DOTA.tmp/lang/schinese"
    NSString *path = [[self langRoot] stringByAppendingPathComponent:lang];
    [self createFolderIfNeed:path];
    return path;
}


@end
