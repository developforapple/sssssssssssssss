//
//  SPResourceManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/12.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>

@interface SPResourceManager : NSObject

// 是否需要初始化数据库
+ (BOOL)needInitializeDatabase;

// 当前本地化语言
@property (copy, nonatomic) NSString *lang;
// 本地化文件路径
@property (copy, nonatomic) NSString *langPath;

// 数据库路径
@property (copy, nonatomic) NSString *dbPath;
// 基础数据路径
@property (copy, nonatomic) NSString *baseDataPath;

// 基础数据远程文件
@property (strong, nonatomic) AVFile *baseDataFile;
// 语言远程文件
@property (strong, nonatomic) AVFile *langFile;
// 语言补丁远程文件
@property (strong, nonatomic) NSArray<AVFile *> *langPatchFiles;

@property (copy, nonatomic) NSNumber *needUpdate;
@property (strong, nonatomic) NSError *error;

// 检查完毕后，发生错误：存放于error，是否需要更新：存放于needUpdate
- (void)checkUpdate;

@end
