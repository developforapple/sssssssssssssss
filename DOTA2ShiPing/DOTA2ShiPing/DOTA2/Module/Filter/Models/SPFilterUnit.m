//
//  SPFilterUnit.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterUnit.h"

@implementation SPFilterUnit

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kind = SPFilterKindUnit;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ title:%@ object:%@",[super description],_title,_object];
}

@end
