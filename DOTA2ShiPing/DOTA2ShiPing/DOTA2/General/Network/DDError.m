//
//  DDError.m
//
//  Created by WangBo on 2017/4/1.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "DDError.h"

@implementation DDError

+ (instancetype)error:(NSError *)err
{
    if (!err) return nil;
    DDError *error = [DDError new];
    error.error = err;
    error.errcode = err.code;
    error.msg = [NSString stringWithFormat:@"网络错误 code:%ld",(long)err.code];
    NSLog(@"%@",err);
    return error;
}

+ (instancetype)dataError:(id)response
{
    if (!response) return nil;
    if (![response isKindOfClass:[NSDictionary class]]) return nil;
    
    NSInteger result = [response[@"result"] integerValue];
    if (result == 0) return nil;
    
    NSString *code = response[@"errcode"];
    DDError *error = [DDError new];
    error.errcode = code?[code integerValue]:result;
    error.msg = response[@"msg"]?:[NSString stringWithFormat:@"网络错误 code:%@",code];
    return error;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"\nerrcode:%ld msg:%@ error:%@",(long)self.errcode,self.msg,self.error];
}

@end
