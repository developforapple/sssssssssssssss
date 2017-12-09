//
//  SPLocalMapping.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/13.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPLocalMapping.h"
#import "VDFParser.h"
#import <SSZipArchive.h>
#import "SPPathManager.h"
#import "SPLogHelper.h"

const long long kMagicNumber = 1010110203019LL;

static NSString *pwd = @"wwwbbat.DOTA2.19880920";
#define FileManager [NSFileManager defaultManager]

@implementation SPLocalMapping

+ (NSString *)langMainFilePath:(NSString *)lang
{
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:@"lang.json"];
}

+ (NSString *)langPatchFilePath:(NSString *)lang
{
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:@"lang_patch.json"];
}

+ (NSString *)langPatchFilePath:(NSString *)lang version:(long long)version
{
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:[NSString stringWithFormat:@"lang_patch_%lld.json",version]];
}

+ (NSString *)changeLogFilePath:(NSString *)lang version:(long long)version
{
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:[NSString stringWithFormat:@"change_log_%lld.json",version]];
}

+ (NSString *)langVersionPath
{
    return [[SPPathManager langRoot] stringByAppendingPathComponent:@"lang_version.txt"];
}

+ (NSDictionary *)langVersion
{
    NSString *path = [self langVersionPath];
    if ([FileManager fileExistsAtPath:path]) {
        return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
    }else{
        return @{};
    }
}

+ (void)saveLangVersion:(NSDictionary *)langVersion
{
    NSString *path = [self langVersionPath];
    NSData *data = [NSJSONSerialization dataWithJSONObject:langVersion options:kNilOptions error:nil];
    NSAssert(data, @"数据不能为空");
    [FileManager removeItemAtPath:path error:nil];
    [data writeToFile:path atomically:YES];
    SPLog(@"保存主文件版本完成");
}

+ (BOOL)updateLangDataIfNeed:(NSString *)lang
{
    // 生成最新的本地化数据
    SPLog(@"准备读取本地化文件，语言：%@",lang);
    NSDictionary *newLangDict = [self loadLocalDataWithLang:lang];
    if (!newLangDict) {
        SPLog(@"读取本地化文件出错了。中断。");
        return NO;
    }
    
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    // 主版本号，如果需要更新主文件，就用此版本号。不需要更新主文件，依然用旧主版本号
    long long mainVersion = time - kMagicNumber;
    // 补丁版本号，更新后总是使用此版本号
    long long patchVersion = time - kMagicNumber;
    
    BOOL langMainFileSuc = YES;
    
    NSString *langPath = [self langMainFilePath:lang];
    if (![FileManager fileExistsAtPath:langPath]) {
        //主文件不存在，重新生成
        
        SPLog(@"没有发现主文件！重新创建");
        
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:newLangDict options:kNilOptions error:&error];
        if (!data || error) {
            SPLog(@"创建本地化二进制数据失败！！！");
            return NO;
        }
        
        BOOL created = [data writeToFile:langPath atomically:YES];
        if (!created) {
            SPLog(@"保存主语言文件失败！");
            return NO;
        }
        
        SPLog(@"保存主语言文件成功！");
        
        // 创建一个空的补丁文件
        SPLog(@"准备创建补丁文件");
        NSDictionary *dif = @{};
        NSData *difData = [NSJSONSerialization dataWithJSONObject:dif options:kNilOptions error:&error];
        if (!difData || error) {
            SPLog(@"生成补丁文件失败！");
            return NO;
        }

        NSString *langPatchFilePath = [self langPatchFilePath:lang version:patchVersion];
        [FileManager removeItemAtPath:langPatchFilePath error:nil];
        BOOL suc = [difData writeToFile:langPatchFilePath atomically:YES];
        if (!suc) {
            SPLog(@"补丁文件保存失败！");
            return NO;
        }
        SPLog(@"保存补丁文件完成");
        
        // 更新版本号
        SPLog(@"更新语言版本号");
        NSMutableDictionary *langVersion = [NSMutableDictionary dictionaryWithDictionary:[self langVersion]];
        langVersion[lang] = @(mainVersion);
        langVersion[[NSString stringWithFormat:@"%@_patch",lang]] = @(patchVersion);
        SPLog(@"文件版本：%@",langVersion);
        [self saveLangVersion:langVersion];
        
        langMainFileSuc = [self createLangMainZipFile:lang];
        
    }else{
        // 主文件存在，比较差异
        SPLog(@"主文件已存在");
        NSError *error;
        NSData *oldLangData = [NSData dataWithContentsOfFile:langPath];
        NSDictionary *oldLangDict = [NSJSONSerialization JSONObjectWithData:oldLangData options:kNilOptions error:&error];
        if (error) {
            SPLog(@"读取旧本地化文件失败！");
            return NO;
        }
        
        // 新增部分
        NSMutableSet *add = [NSMutableSet set];
        // 修改部分
        NSMutableSet *modify = [NSMutableSet set];
        
        // 比较旧主文件和新主文件的差异，差异部分即为此次的补丁内容。
        SPLog(@"比较旧主文件和新主文件差异");
        NSMutableDictionary *newPatch = [NSMutableDictionary dictionary];
        {
            for (NSString *newKey in newLangDict) {
                NSString *newValue = newLangDict[newKey];
                NSString *oldValue = oldLangDict[newKey];
                if (!oldValue) {
                    // 新出现的key
                    [add addObject:newKey];
                    newPatch[newKey] = newValue;
                }else if (![oldValue isEqualToString:newValue]) {
                    // 旧的key，但是value变了
                    [modify addObject:newKey];
                    newPatch[newKey] = newValue;
                }
            }
        }
        SPLog(@"共有%d条补丁条目",(int)newPatch.count);
        
        
        // 保存补丁到文件
        {
            SPLog(@"准备创建补丁文件");
            NSData *patchData = [NSJSONSerialization dataWithJSONObject:newPatch options:kNilOptions error:&error];
            if (!patchData || error) {
                SPLog(@"生成补丁文件失败！");
                return NO;
            }
            NSString *langPatchFilePath = [self langPatchFilePath:lang version:patchVersion];
            [FileManager removeItemAtPath:langPatchFilePath error:nil];
            BOOL suc = [patchData writeToFile:langPatchFilePath atomically:YES];
            if (!suc) {
                SPLog(@"补丁文件保存失败！");
                return NO;
            }
            SPLog(@"创建补丁文件完成");
        }
        

        // 对比旧patch和新patch，计算本次更新的更新内容
        {
            // 保存
            SPLog(@"保存 Change Log");
            NSMutableDictionary *changeLog = [NSMutableDictionary dictionary];
            changeLog[@"add"] = [add objectEnumerator].allObjects;
            changeLog[@"modify"] = [modify objectEnumerator].allObjects;
            NSData *changeLogData = [NSJSONSerialization dataWithJSONObject:changeLog options:kNilOptions error:nil];
            NSString *changeLogPath = [self changeLogFilePath:lang version:patchVersion];
            [FileManager removeItemAtPath:changeLogPath error:nil];
            BOOL suc = [changeLogData writeToFile:changeLogPath atomically:YES];
            if (!suc) {
                SPLog(@"保存 Change Log出错");
                return NO;
            }
        }
        
        // 更新版本号
        {
            SPLog(@"更新版本号");
            NSMutableDictionary *langVersion = [NSMutableDictionary dictionaryWithDictionary:[self langVersion]];
            langVersion[[NSString stringWithFormat:@"%@_patch",lang]] = @(patchVersion);
            [self saveLangVersion:langVersion];
            SPLog(@"文件版本：%@",langVersion);
        }
    }
    if (!langMainFileSuc) {
        SPLog(@"主文件出错。中断。");
        return NO;
    }
    
    BOOL langPatchFileSuc = [self createLangPatchZipFile:lang version:patchVersion];
    if (!langPatchFileSuc) {
        SPLog(@"语言补丁出错。中断。");
        return NO;
    }
    
    return YES;
}

+ (NSDictionary *)loadLocalDataWithLang:(NSString *)lang
{
    //从三种文件获取本地化
    // 1 /Applications/SteamLibrary/SteamApps/common/dota 2 beta/game/dota/panorama/localization/dota_%@.txt
    // 2 /Applications/SteamLibrary/SteamApps/common/dota 2 beta/game/dota/resource/dota_%@.txt
    // 3 /Applications/SteamLibrary/SteamApps/common/dota 2 beta/game/dota/resource/items_%@.txt
    
    SPLog(@"开始生成本地化映射：语言：%@",lang);
    
    NSString *dotaPath = @"/Applications/SteamLibrary/SteamApps/common/dota 2 beta/game/dota";
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    {
        //file 1
        NSString *filePath = [dotaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"panorama/localization/dota_%@.txt",lang]];
        SPLog(@"文件1：%@",filePath);
        if (![fm fileExistsAtPath:filePath]) {
            SPLog(@"找不到文件路径：%@",filePath);
            return nil;
        }
        
        NSError *error;
        NSString *txt = [NSString stringWithContentsOfFile:filePath encoding:NSUTF16LittleEndianStringEncoding error:&error];
        if (error || txt.length == 0) {
            SPLog(@"读取文件出错：%@",error);
            return nil;
        }

        NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
        VDFNode *root = [VDFParser parse:data];
        VDFNode *dota = [root firstChildWithKey:@"dota"];
        NSDictionary *tokens = [dota datasDict];
        [dict addEntriesFromDictionary:tokens];
        SPLog(@"文件1找到 %d 条数据",(int)tokens.count);
        [dict addEntriesFromDictionary:tokens];
    }
    
    {
        // file 2
        NSString *filePath = [dotaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"resource/dota_%@.txt",lang]];
        SPLog(@"文件2：%@",filePath);
        if (![fm fileExistsAtPath:filePath]) {
            SPLog(@"找不到文件路径：%@",filePath);
            return nil;
        }
        
        NSError *error;
        NSString *txt = [NSString stringWithContentsOfFile:filePath encoding:NSUTF16LittleEndianStringEncoding error:&error];
        if (error || txt.length == 0) {
            SPLog(@"读取文件出错：%@",error);
            return nil;
        }
        
        NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
        VDFNode *root = [VDFParser parse:data];
        VDFNode *lang = [root firstChildWithKey:@"lang"];
        VDFNode *Tokens = [lang firstChildWithKey:@"Tokens"];
        NSDictionary *tokens = [Tokens datasDict];
        SPLog(@"文件2找到 %d 条数据",(int)tokens.count);
        [dict addEntriesFromDictionary:tokens];
    }
    
    {
        // file 3
        NSString *filePath = [dotaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"resource/items_%@.txt",lang]];
        SPLog(@"文件3：%@",filePath);
        if (![fm fileExistsAtPath:filePath]) {
            SPLog(@"找不到文件路径：%@",filePath);
            return nil;
        }
        
        NSError *error;
        NSString *txt = [NSString stringWithContentsOfFile:filePath encoding:NSUTF16LittleEndianStringEncoding error:&error];
        if (error || txt.length == 0) {
            SPLog(@"读取文件出错：%@",error);
            return nil;
        }
        
        NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
        VDFNode *root = [VDFParser parse:data];
        VDFNode *lang = [root firstChildWithKey:@"lang"];
        VDFNode *Tokens = [lang firstChildWithKey:@"Tokens"];
        NSDictionary *tokens = [Tokens datasDict];
        SPLog(@"文件3找到 %d 条数据",(int)tokens.count);
        [dict addEntriesFromDictionary:tokens];
    }
    
    SPLog(@"创建本地化映射成功，共 %d 条数据",(int)dict.count);
    return dict;
}

+ (BOOL)createLangMainZipFile:(NSString *)lang
{
    SPLog(@"创建主文件压缩包：%@",lang);
    NSString *filePath = [self langMainFilePath:lang];
    if (![FileManager fileExistsAtPath:filePath]) {
        SPLog(@"主文件不存在！");
        return NO;
    }
    NSString *zipPath = [self langMainFileZipPath:lang];
    [FileManager removeItemAtPath:zipPath error:nil];
    BOOL suc = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[filePath] withPassword:pwd];
    if (!suc) {
        SPLog(@"创建主文件压缩包失败！");
        return NO;
    }
    SPLog(@"创建主文件压缩包完成");
    return YES;
}

+ (BOOL)createLangPatchZipFile:(NSString *)lang version:(long long )version
{
    SPLog(@"创建补丁文件压缩包：%@",lang);
    NSString *filePath = [self langPatchFilePath:lang version:version];
    if (![FileManager fileExistsAtPath:filePath]) {
        SPLog(@"补丁文件不存在！");
        return NO;
    }
    
    NSString *renameFilePath = [self langPatchFilePath:lang];
    [FileManager removeItemAtPath:renameFilePath error:nil];
    [FileManager copyItemAtPath:filePath toPath:renameFilePath error:nil];
    if (![FileManager fileExistsAtPath:renameFilePath]) {
        SPLog(@"补丁文件复制出错！");
        return NO;
    }
    
    NSString *zipPath = [self langPatchFileZipPath:lang];
    [FileManager removeItemAtPath:zipPath error:nil];
    BOOL suc = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[renameFilePath] withPassword:pwd];
    if (!suc) {
        SPLog(@"创建补丁文件压缩包失败！");
        return NO;
    }
    SPLog(@"创建补丁文件压缩包完成");
    return YES;
}

+ (NSString *)langMainFileZipPath:(NSString *)lang
{
    NSDictionary *langVersion = [self langVersion];
    NSNumber *version = langVersion[lang];
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.zip",lang,version]];
}

+ (NSString *)langPatchFileZipPath:(NSString *)lang
{
    NSDictionary *langVersion = [self langVersion];
    NSNumber *version = langVersion[lang];
    NSNumber *patchVersion = langVersion[[NSString stringWithFormat:@"%@_patch",lang]];
    return [[SPPathManager langPath:lang] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@_patch.zip",lang,version,patchVersion]];
}

@end

NSString *const kSPLanguageSchinese = @"schinese";
NSString *const kSPLanguageEnglish = @"english";
