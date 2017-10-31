//
//  SPGamepediaAPI.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaAPI.h"
#import "SPGamepediaSerializer.h"

//https://dota2.gamepedia.com/api.php?action=parse&format=json&prop=text&page=Aria_of_the_Wild_Wind_Set

@interface SPGamepediaAPI ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SPGamepediaAPI

+ (instancetype)shared
{
    static SPGamepediaAPI *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPGamepediaAPI new];
        
        NSURL *baseURL = [NSURL URLWithString:@"https://dota2.gamepedia.com"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [manager.requestSerializer setValue:@"dota2.gamepedia.com" forHTTPHeaderField:@"Host"];
        [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1" forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
        [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [manager setResponseSerializer:[SPGamepediaSerializer new]];
        
        shared.manager = manager;
    });
    return shared;
}

- (NSDictionary *)defaultWebAPIParams
{
    return @{@"action":@"parse",
             @"format":@"json",
             @"prop":@"text"};
}

- (void)fetchItem:(NSString *)itemName
       completion:(SPGamepediaAPICompletion)completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self defaultWebAPIParams]];
    dict[@"page"] = itemName;
    
    [self.manager GET:@"api.php" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        if (completion) {
            completion(YES,nil,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        if (completion) {
            completion(NO,error,nil);
        }
    }];
}

@end
