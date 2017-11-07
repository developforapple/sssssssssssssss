//
//  SPItemPriceLoader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPriceLoader.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TFHpple.h"

@implementation SPItemDota2Price

- (instancetype)initWithPrice:(NSString *)price originPrice:(NSString *)originPrice
{
    self = [super init];
    if (self) {
        self.price = price;
        self.originPrice = originPrice;
        
        if (!price.length && !originPrice.length) {
            self.error = @"未找到该物品";
        }
    }
    return self;
}

@end

@implementation SPItemSteamPrice

@end

@implementation SPItemPriceLoader

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(void (^)(SPItemDota2Price *price))completion
{
    RunOnGlobalQueue(^{
        NSURL *url = [NSURL URLWithString:@"http://store.dota2.com.cn/itemdetails/20254"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        TFHpple *root = [TFHpple hppleWithHTMLData:data];
        
        TFHppleElement *box = [root searchWithXPathQuery:@"//div[@class='Price contentBox']"].firstObject;
        
        NSString *price,*originPrice;
        
        for (TFHppleElement *element in box.children) {
            
            if (element.isTextNode) {
                NSString *text = [element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (text.length > 0) {
                    price = text;
                }
            }else if([[element objectForKey:@"class"] isEqualToString:@"OriginalPrice"]){
                originPrice = [element.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
        }
        
        RunOnMainQueue(^{
            
            SPItemDota2Price *p = [[SPItemDota2Price alloc] initWithPrice:price originPrice:originPrice];
            if (completion) {
                completion(p);
            }
        });
    });
}

@end
