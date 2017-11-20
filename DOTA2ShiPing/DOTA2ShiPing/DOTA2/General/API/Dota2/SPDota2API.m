//
//  SPDota2API.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPDota2API.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation SPDota2API

+ (void)fetchDota2SpecilPriceItem:(void (^)(SPDota2MarketItem *item))completion
{
    RunOnGlobalQueue(^{
        
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://members.dota2.com.cn/dota/spotlight?jsonpCallback=%%20&r=%d",arc4random_uniform(999999)]] encoding:NSUTF8StringEncoding error:nil];
        NSString *js = [NSString stringWithFormat:@"var abc = %@",string];
        JSContext *ctx = [[JSContext alloc] init];
        [ctx evaluateScript:js];
        NSDictionary *dict = [[ctx globalObject] toDictionary][@"abc"];
        SPDota2MarketItem *item = [SPDota2MarketItem yy_modelWithJSON:dict];
        [item save];
        
        RunOnMainQueue(^{
            if (completion) {
                completion(item);
            }
        });
    });
}

@end
