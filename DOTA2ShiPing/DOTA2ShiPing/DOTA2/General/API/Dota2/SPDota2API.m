//
//  SPDota2API.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPDota2API.h"

@import Hpple;
#import <JavaScriptCore/JavaScriptCore.h>

@implementation SPDota2API

+ (void)fetchDota2SpecilPriceItem:(void (^)(SPDota2SpotlightItem *item))completion
{
    if (!completion) return;
    
    RunOnGlobalQueue(^{
        
        long long time = (long long)[[NSDate date] timeIntervalSince1970];
        NSString *url = [NSString stringWithFormat:@"http://store.dota2.com.cn/featured/?ajax=1&l=schinese&c=RMB&v=_M%lld",time];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        SPDota2SpotlightItem *item;
        
        if (data) {
            NSError *error;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (obj && [obj isKindOfClass:[NSDictionary class]]){
                NSString *html = obj[@"spotlight"][@"html"];
                
                NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
                TFHpple *root = [TFHpple hppleWithHTMLData:data];
                
                TFHppleElement *aNode = [root searchWithXPathQuery:@"//a[contains(@class,'ItemImage')]"].firstObject;
                NSString *href = [aNode objectForKey:@"href"];
                
                TFHppleElement *imgNode = [root searchWithXPathQuery:@"//img[@class='ItemImageDropShadow']"].firstObject;
                NSString *src = [imgNode objectForKey:@"src"];
                
                SPDota2SpotlightItem *item = [SPDota2SpotlightItem new];
                item.href = href;
                item.src = src;
                [item save];
            }
        }
        RunOnMainQueue(^{
            completion(item);
        });
    });
}

@end
