//
//  DDResponse.m
//
//  Created by WangBo on 2017/4/1.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "DDResponse.h"

@interface DDResponse ()
@property (assign, readwrite, nonatomic) BOOL suc;
@property (strong, readwrite, nonatomic) DDError *error;
@end

@implementation DDResponse

+ (instancetype)response:(NSURLResponse *)response object:(NSDictionary *)object
{
    if (!response) return nil;
    if (!object || ![object isKindOfClass:[NSDictionary class]]) return nil;
    
    DDResponse *resp = [DDResponse new];
    resp.result = [object[@"result"] integerValue];
    resp.id = [object[@"id"] integerValue];
    resp.msg = object[@"msg"];
    resp.sortTime = object[@"sortTime"];
    resp.data = object;
    
    resp.suc = resp.result == DDRespResultSuc;
    if (!resp.suc) {
        resp.error = [DDError dataError:object];
    }
    if ([response respondsToSelector:@selector(statusCode)]) {
        resp.statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    return resp;
}

+ (instancetype)response:(NSURLResponse *)response error:(NSError *)error
{
    if (!error) return nil;
    
    DDResponse *resp = [DDResponse new];
    resp.error = [DDError error:error];
    resp.suc = NO;
    if ([response respondsToSelector:@selector(statusCode)]) {
        resp.statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    return resp;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"\nresult:%ld id:%ld msg:%@ statusCode:%ld error:%@",(long)self.result,(long)self.id,self.msg,(long)self.statusCode,self.error];
}

- (BOOL)networkError
{
    return self.error && self.statusCode != 200;
}

@end
