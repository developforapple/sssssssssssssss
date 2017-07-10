//
//  SPMaxPlusAPI.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPMaxPlusAPI.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

@interface SPMaxPlusAPI ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SPMaxPlusAPI

+ (instancetype)shared
{
    static SPMaxPlusAPI *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPMaxPlusAPI new];
        
        NSURL *baseURL = [NSURL URLWithString:@"http://api.maxjia.com:80/"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [manager.requestSerializer setValue:@"api.maxjia.com:80" forHTTPHeaderField:@"Host"];
        [manager.requestSerializer setValue:@"http://api.maxjia.com/" forHTTPHeaderField:@"Referer"];
        [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.36 ApiMaxJia/1.0" forHTTPHeaderField:@"User-Agent"];
        shared.manager = manager;
        
    });
    return shared;
}

- (NSURLSessionDataTask *)searchUser:(NSString *)keywords
                          completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion
{
    if (!completion) {
        return nil;
    }
    
    if (keywords.length == 0) {
        completion(NO,nil,@"搜索内容不能为空");
    }
    
    long long time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *params = [self fullParamsWithParams:@{@"q":keywords,
                                                        @"_time":@(time)}];
    
    return
    [self.manager GET:@"api/search" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *players = responseObject[@"result"][@"players"];
        completion(YES,players,responseObject[@"msg"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,nil,@"网络错误");
    }];
}

- (NSDictionary *)fullParamsWithParams:(NSDictionary *)params
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    dict[@"phone_num"] = @"00000000000";
    dict[@"pkey"] = @"randpkey";
    dict[@"os_type"] = [UIDevice currentDevice].systemName;
    dict[@"os_version"] = [UIDevice currentDevice].systemVersion;
    dict[@"version"] = @"3.3.4";
    return dict;
}

@end
