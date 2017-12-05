//
//  SPBaseData.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBaseData.h"
#import "SPLocale.h"

@import FCUUID;

@interface SPBaseData ()

@end

@implementation SPBaseData

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

+ (void)saveItemAtPath:(NSString *)atPath from:(NSString *)fromPath
{
    NSError *error;
    [FileManager removeItemAtPath:atPath error:nil];
    [FileManager moveItemAtPath:fromPath toPath:atPath error:&error];
    NSAssert(!error, @"发生了错误");
}

+ (NSString *)rootFolder
{
    NSString *path = [AppDocumentsPath stringByAppendingPathComponent:@".app_data"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)baseDataFolder
{
    NSString *path = [[self rootFolder] stringByAppendingPathComponent:@"basedata"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langFolder
{
    NSString *path = [[self rootFolder] stringByAppendingPathComponent:@"lang"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)langPath:(NSString *)lang
{
    if (!lang) return nil;
    NSString *path = [[self langFolder] stringByAppendingPathComponent:lang];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)tmpFolder
{
    NSString *path = [[self rootFolder] stringByAppendingPathComponent:@"tmp"];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)randomString
{
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    uint32_t random = arc4random_uniform(UINT32_MAX);
    NSString *name = [NSString stringWithFormat:@"%lld_%ld",time,random];
    return name;
}

+ (NSString *)randomTmpFilePath
{
    return [[self tmpFolder] stringByAppendingPathComponent:[self randomString]];
}

+ (NSString *)randomTmpFolder
{
    NSString *path = [[self tmpFolder] stringByAppendingPathComponent:[self randomString]];
    [self createFolderIfNeed:path];
    return path;
}

+ (NSString *)dataPath
{
    return [[self baseDataFolder] stringByAppendingPathComponent:@"data.json"];
}

+ (NSString *)dbPath
{
    return [[self baseDataFolder] stringByAppendingPathComponent:@"item.db"];
}

+ (NSString *)langMainFilePath:(NSString *)lang
{
    NSString *langPath = [self langPath:lang];
    if (!langPath) return nil;
    return [langPath stringByAppendingPathComponent:@"lang.json"];
}

+ (NSString *)langPatchFilePath:(NSString *)lang
{
    NSString *langPath = [self langPath:lang];
    if (!langPath) return nil;
    return [langPath stringByAppendingPathComponent:@"lang_patch.json"];
}

+ (BOOL)isBaseDataValid
{
    return  [FileManager fileExistsAtPath:[self dataPath]] &&
            [FileManager fileExistsAtPath:[self dbPath]];
}

+ (BOOL)isLangDataValid:(NSString *)lang
{
    if (![SPLocale isLangSupported:lang]) return NO;
    NSString *mainFile = [self langMainFilePath:lang];
    if (!mainFile) return NO;
    return [FileManager fileExistsAtPath:mainFile];
}

// 读取基础数据
+ (id)readDataJSON
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[self dataPath] options:NSDataReadingMappedIfSafe error:&error];
    if (!data || error) {
        NSLog(@"读取基础数据错误：%@",error);
        return nil;
    }
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!object || error) {
        NSLog(@"解析基础数据错误：%@",error);
        return nil;
    }
    return object;
}

// 读取语言数据
+ (id)readLangData:(NSString *)lang
{
    if (![self isLangDataValid:lang]) return nil;
    
    NSString *mainFilePath = [self langMainFilePath:lang];
    NSString *patchFilePath = [self langPatchFilePath:lang];
    
    NSError *error;
    
    NSData *mainData = [NSData dataWithContentsOfFile:mainFilePath options:NSDataReadingMappedIfSafe error:&error];
    if (!mainData || error) {
        NSLog(@"读取语言主数据失败！：%@",error);
        return nil;
    }
    NSMutableDictionary *mainObject = [NSJSONSerialization JSONObjectWithData:mainData options:NSJSONReadingMutableContainers error:&error];
    if (!mainObject || error) {
        NSLog(@"解析语言主数据失败！：%@",error);
        return  nil;
    }
    
    mainData = nil;
    
    NSData *patchData = [NSData dataWithContentsOfFile:patchFilePath options:NSDataReadingMappedIfSafe error:&error];
    if (!patchData || error) {
        NSLog(@"读取语言补丁数据失败！%@：%@",patchFilePath,error);
        return nil;
    }
    NSMutableDictionary *patchObject = [NSJSONSerialization JSONObjectWithData:patchData options:kNilOptions error:&error];
    if (!patchObject || error) {
        NSLog(@"解析语言补丁数据失败！%@：%@",patchFilePath,error);
        return nil;
    }
    [mainObject addEntriesFromDictionary:patchObject];
    patchData = nil;
    
    return mainObject;
}

+ (void)writeDataJSON:(NSData *)data
{
    if (!data) return;
    RunOnMainQueue(^{
        NSString *file = [self dataPath];
        [FileManager removeItemAtPath:file error:nil];
        [data writeToFile:file atomically:YES];
    });
}

// 写入语言数据。
+ (void)writeLangData:(NSData *)data lang:(NSString *)lang
{
    if (!lang || !data) return;
    RunOnMainQueue(^{
        NSString *file = [self langMainFilePath:lang];
        [FileManager removeItemAtPath:file error:nil];
        [data writeToFile:file atomically:YES];
    });
}

// 写入语言补丁数据。
+ (void)writeLangPatchData:(NSData *)data lang:(NSString *)lang
{
    if (!lang || !data) return;
    RunOnMainQueue(^{
        NSString *file = [self langPatchFilePath:lang];
        [FileManager removeItemAtPath:file error:nil];
        [data writeToFile:file atomically:YES];
    });
}

+ (void)writeDB:(NSData *)db
{
    if (!db) return;
    RunOnMainQueue(^{
        NSString *file = [self dbPath];
        [FileManager removeItemAtPath:file error:nil];
        [db writeToFile:file atomically:YES];
    });
}

+ (void)saveDataJSONfrom:(NSString *)path
{
    if (!path || ![FileManager fileExistsAtPath:path]) return;
    RunOnMainQueue(^{
        NSString *toPath = [self dataPath];
        [self saveItemAtPath:toPath from:path];
    });
}

+ (void)saveLangDataFrom:(NSString *)path lang:(NSString *)lang
{
    if (!lang || !path || ![FileManager fileExistsAtPath:path]) return;
    
    RunOnMainQueue(^{
        NSString *toPath = [self langMainFilePath:lang];
        [self saveItemAtPath:toPath from:path];
    });
}

+ (void)saveLangPatchDataFrom:(NSString *)path lang:(NSString *)lang
{
    if (!lang || !path || ![FileManager fileExistsAtPath:path]) return;
    
    RunOnMainQueue(^{
        NSString *toPath = [self langPatchFilePath:lang];
        [self saveItemAtPath:toPath from:path];
    });
}

+ (void)saveDBFrom:(NSString *)path
{
    if (!path || ![FileManager fileExistsAtPath:path]) return;
    
    RunOnMainQueue(^{
        NSString *toPath = [self dbPath];
        [self saveItemAtPath:toPath from:path];
    });
}

@end
