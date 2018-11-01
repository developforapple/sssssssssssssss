//
//  SPDeploy.h
//  SPDev
//
//  Created by wwwbbat on 2018/1/6.
//  Copyright © 2018年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Deploy.h"

@interface SPDeploy : NSObject

@property (assign, nonatomic) BOOL finish;
@property (assign, nonatomic) BOOL success;
@property (assign, nonatomic) NSInteger minVersion;
@property (assign, nonatomic) NSInteger maxVersion;
@property (assign, nonatomic) NSInteger latestVersion;
@property (assign, nonatomic) YGAppDeploy deploy;
@property (strong, nonatomic) NSError *error;

+ (instancetype)instance;

- (void)update;

@end
