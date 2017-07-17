//
//  SPResourceManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/12.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>


/*
 基础数据命名：
    版本号：base_data_version.txt 版本号存放于这个文件的metaData中，key为 version
    压缩文件：base_data_xxxx.zip 其中xxxx为版本号
        压缩包内两个文件： data.json item.db
 
 语言数据命名：
    主文件： xxxx_yyyy.zip 其中xxxx为语言名  yyyy为语言的版本号。本地语言版本号小于服务器语言版本号时，需要更新主文件。
        压缩包内1个文件: lang.json
    补丁文件：xxxx_yyyy_zzzz_patch.zip 其中xxxx为语言名 yyyy为语言的版本号 zzzz为补丁版本号
        压缩包内若1个文件：lang_patch.json
 版本控制：
    在Class:Version表中。
    字段name的值为 base_data_version 的行，控制基础数据版本
    字段name的值为 lang_version_xxxx 的行，控制语言数据版本 其中xxxx为语言名
    版本号保存在 version 字段中
 
 全部压缩文件解压密码为 wwwbbat.DOTA2.19880920 保存在常量 zipPassword 中
*/



/**
 应用需要使用和更新的资源
 */
@interface SPResourceManager : NSObject

// 是否需要初始化数据库
+ (BOOL)needInitializeDatabase;

// 当前本地化语言
@property (copy, readonly, nonatomic) NSString *lang;

// 基础数据远程文件
@property (strong, nonatomic) AVFile *baseDataFile;
// 语言远程文件
@property (strong, nonatomic) AVFile *langFile;
// 语言补丁远程文件
@property (strong, nonatomic) AVFile *langPatchFile;

@property (copy, nonatomic) NSNumber *needUpdate;
@property (strong, nonatomic) NSError *error;

@property (assign, nonatomic) float progress;
@property (copy, nonatomic) void (^downloadCompleted)(void);
@property (copy, nonatomic) void (^unzipCompleted)(void);
@property (copy, nonatomic) void (^completion)(void);

// 检查完毕后，发生错误：存放于error，是否需要更新：存放于needUpdate
- (void)checkUpdate;

//
- (void)beginUpdate;
- (void)beginUnzip;
- (void)saveData;
- (void)serializeData;

@end
