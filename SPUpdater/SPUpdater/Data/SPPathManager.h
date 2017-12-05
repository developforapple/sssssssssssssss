//
//  SPPathManager.h
//  ShiPing
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPathManager : NSObject

+ (void)createFolderIfNeed:(NSString *)path;

+ (NSString *)rootPath;
+ (NSString *)downloadPath;
+ (NSString *)imagePath;
+ (NSString *)baseDataPath;
+ (NSString *)langRoot;
+ (NSString *)langPath:(NSString *)lang;

@end
