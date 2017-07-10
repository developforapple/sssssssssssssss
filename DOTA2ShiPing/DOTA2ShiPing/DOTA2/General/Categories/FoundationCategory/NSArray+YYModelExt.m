//
//  NSArray+YYModelExt.m
//
//  Created by bo wang on 2017/4/21.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "NSArray+YYModelExt.h"

@implementation NSArray (YYModelExt)

+ (NSMutableArray *)modelArrayWithClass:(Class)cls json:(id)json
{
    NSArray *array = [self yy_modelArrayWithClass:cls json:json];
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if ([array respondsToSelector:@selector(addObject:)]) {
        //是可变的
        return (NSMutableArray *)array;
    }else{
        return [NSMutableArray arrayWithArray:array];
    }
}

@end
