//
//  SPResourceManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/12.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPResourceManager : NSObject

// 是否需要初始化数据库
+ (BOOL)needInitializeDatabase;
// 初始化数据库
- (void)initializeDatabase:(void (^)(float p))progressBlock
                completion:(void (^)(BOOL suc,NSError *error))completion;

+ (instancetype)manager;

// 当前本地化语言
@property (copy, nonatomic) NSString *lang;
// 本地化文件路径
@property (copy, nonatomic) NSString *langPath;

// 数据库路径
@property (copy, nonatomic) NSString *dbPath;
// 基础数据路径
@property (copy, nonatomic) NSString *baseDataPath;

- (void)checkUpdate;

@end
