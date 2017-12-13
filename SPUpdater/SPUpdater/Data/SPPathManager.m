//
//  SPPathManager.m
//  ShiPing
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPathManager.h"

#define _yg_cat(a,b) a b
#define _yg_str1(a) # a
#define _yg_str2(a) _yg_str1(a)
#define _yg_prefix1 @
#define _yg_prefix2 _yg_prefix1
#define _yg_toNSString1(a) _yg_cat(_yg_prefix2, _yg_str2(a))
#define YGTokenToString(token) _yg_toNSString1(token)


#define FileManager [NSFileManager defaultManager]

@implementation SPPathManager

+ (void)createFolderIfNeed:(NSString *)path
{
    NSError *error;
    BOOL isDirectory = NO;
    BOOL exists = [FileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!exists) {
        BOOL suc = [FileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(suc && !error, @"出错了");
    }else if(!isDirectory){
        [FileManager removeItemAtPath:path error:nil];
        BOOL suc = [FileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSAssert(suc && !error, @"出错了");
    }
}

+ (NSString *)rootPath
{
    NSString *path = YGTokenToString(TMPFILEPATH);
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)statePath
{
    return [[self rootPath] stringByAppendingPathComponent:@"State.json"];
}

+ (NSString *)downloadPath
{
//    @"${SRCROOT}/Files/download"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"download"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)imagePath
{
//    @"${SRCROOT}/Files/image"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"image"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)baseDataPath
{
//    @"${SRCROOT}/Files/basedata"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"basedata"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langRoot
{
//    @"${SRCROOT}/Files/lang"
    NSString *path = [[self rootPath] stringByAppendingPathComponent:@"lang"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langPath:(NSString *)lang
{
//    @"${SRCROOT}/Files/lang/schinese"
    NSString *path = [[self langRoot] stringByAppendingPathComponent:lang];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)dotaManifestPath
{
    return @"/Applications/SteamLibrary/SteamApps/appmanifest_570.acf";
}

@end
