//
//  SPBaseData.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBaseData.h"
#import "SPLocale.h"

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
    [FileManager removeItemAtPath:atPath error:&error];
    NSAssert(!error, @"发生了错误");
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

+ (NSString *)randomTmpFilePath
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [[self tmpFolder] stringByAppendingPathComponent:[@(time) stringValue]];
}

+ (NSString *)randomTmpFolder
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *path = [[self tmpFolder] stringByAppendingPathComponent:[@(time) stringValue]];
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

+ (NSString *)langPatchFilePath:(NSString *)lang patch:(NSString *)patch
{
    NSString *langPath = [self langPath:lang];
    if (!langPath) return nil;
    NSString *name = [NSString stringWithFormat:@"lang_%@.json",patch];
    return [langPath stringByAppendingPathComponent:name];
}

+ (NSArray<NSString *> *)langPatchFilePaths:(NSString *)lang
{
    NSString *langPath = [self langPath:lang];
    if (!langPath) return @[];
    
    // 需要测试
    NSMutableArray *paths = [NSMutableArray array];
    NSDirectoryEnumerator *enumerator = [FileManager enumeratorAtPath:langPath];
    NSString *aFile;
    while ( (aFile = [enumerator nextObject]) ) {
        BOOL isDirectory = NO;
        if ([FileManager fileExistsAtPath:aFile isDirectory:&isDirectory] &&
            !isDirectory &&
            [[aFile lastPathComponent] hasPrefix:@"lang_"] &&
            [[aFile pathExtension] isEqualToString:@"json"]) {
            [paths addObject:aFile];
        }
    }
    
    [paths sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        long long v1 = [[[obj1 lastPathComponent] stringByDeletingPathExtension] longLongValue];
        long long v2 = [[[obj2 lastPathComponent] stringByDeletingPathExtension] longLongValue];
        return v1 < v2 ? NSOrderedAscending : ( v1 == v2 ? NSOrderedSame : NSOrderedDescending ) ;
    }];
    
    return paths;
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
    NSArray *patchFilePaths = [self langPatchFilePaths:lang];
    
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
    
    for (NSString *patchFile in patchFilePaths) {
        NSData *patchData = [NSData dataWithContentsOfFile:patchFile options:NSDataReadingMappedIfSafe error:&error];
        if (!patchData || error) {
            NSLog(@"读取语言补丁数据失败！%@：%@",patchFile,error);
            continue;
        }
        NSMutableDictionary *patchObject = [NSJSONSerialization JSONObjectWithData:patchData options:kNilOptions error:&error];
        if (!patchObject || error) {
            NSLog(@"解析语言补丁数据失败！%@：%@",patchFile,error);
            continue;
        }
        [mainObject addEntriesFromDictionary:patchObject];
        patchData = nil;
    }
    
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
+ (void)writeLangData:(NSData *)data lang:(NSString *)lang patch:(NSString *)patch
{
    if (!lang || !patch || !data) return;
    RunOnMainQueue(^{
        NSString *file = [self langPatchFilePath:lang patch:patch];
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

+ (void)saveLangDataFrom:(NSString *)path lang:(NSString *)lang patch:(NSString *)patch
{
    if (!lang || !path || !patch || ![FileManager fileExistsAtPath:path]) return;
    
    RunOnMainQueue(^{
        NSString *toPath = [self langPatchFilePath:lang patch:patch];
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
