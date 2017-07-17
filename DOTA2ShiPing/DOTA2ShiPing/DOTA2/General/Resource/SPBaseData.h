//
//  SPBaseData.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

// 文件结构
/*  /Documents
        /.app_data
            /basedata
                /data.json
                /item.db
            /lang
                /schinese
                    /lang.json
                    /lang_xxx.json
                /english
                    /lang.json
                    /lang_xxx.json
            /tmp
 
 */

@interface SPBaseData : NSObject

// 根目录
+ (NSString *)rootFolder;
// 保存基础数据
+ (NSString *)baseDataFolder;
// 保存所有语言的总目录
+ (NSString *)langFolder;
// 指定语言文件的目录
+ (NSString *)langPath:(NSString *)lang;
// 临时文件
+ (NSString *)tmpFolder;
// 生成一个随机临时文件路径
+ (NSString *)randomTmpFilePath;
// 生成一个随机临时文件夹
+ (NSString *)randomTmpFolder;

// 基础数据路径
+ (NSString *)dataPath;
// 饰品数据库路径
+ (NSString *)dbPath;
// 一个语言的主文件路径
+ (NSString *)langMainFilePath:(NSString *)lang;
// 一个语言的补丁文件路径
+ (NSString *)langPatchFilePath:(NSString *)lang;

// 基础数据是否有效
+ (BOOL)isBaseDataValid;
// 本地化文件是否有效
+ (BOOL)isLangDataValid:(NSString *)lang;

// 读取数据对象
// 读取基础数据 data.json
+ (id)readDataJSON;
// 读取语言数据
+ (id)readLangData:(NSString *)lang;

// 写入二进制数据
// 写入基础数据
+ (void)writeDataJSON:(NSData *)data;
// 写入语言主数据。
+ (void)writeLangData:(NSData *)data lang:(NSString *)lang;
// 写入语言补丁数据。
+ (void)writeLangPatchData:(NSData *)data lang:(NSString *)lang;
// 写入数据库
+ (void)writeDB:(NSData *)db;

// 写入二进制数据
// 从path保存到基础数据
+ (void)saveDataJSONfrom:(NSString *)path;
// 从path保存到语言主数据
+ (void)saveLangDataFrom:(NSString *)path lang:(NSString *)lang;
// 从path保存到语言补丁数据
+ (void)saveLangPatchDataFrom:(NSString *)path lang:(NSString *)lang;
// 从path保存到数据库
+ (void)saveDBFrom:(NSString *)path;

@end
