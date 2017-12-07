//
//  SPObject.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/27.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPObject.h"

@implementation SPObject

- (void)dealloc
{
//    SPLog(@"%@ 释放",NSStringFromClass([self class]));
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

@end
