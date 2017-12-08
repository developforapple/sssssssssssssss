//
//  SPLocalMapping.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/13.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const long long kMagicNumber ;

// Dota2 游戏目录下的本地化数据

@interface SPLocalMapping : NSObject

// 做的事情：
// 1：从游戏目录中提取指定语言的全部本地化文件
// 2：如果主文件不存在，创建主文件，创建空补丁文件
// 3：如果主文件存在，比较差异，创建补丁文件
+ (BOOL)updateLangDataIfNeed:(NSString *)lang;

// key: schinese 语言主文件版本
// key: schinese_patch 语言补丁版本
+ (NSDictionary *)langVersion;

+ (NSString *)langVersionPath;

+ (NSString *)langMainFileZipPath:(NSString *)lang;
+ (NSString *)langPatchFileZipPath:(NSString *)lang;

+ (NSString *)changeLogFilePath:(NSString *)lang version:(long long)version;

@end


FOUNDATION_EXTERN NSString *const kSPLanguageSchinese;  //简体中文
FOUNDATION_EXTERN NSString *const kSPLanguageEnglish;   //英文
