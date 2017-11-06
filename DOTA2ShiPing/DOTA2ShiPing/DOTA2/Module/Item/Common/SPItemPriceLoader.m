//
//  SPItemPriceLoader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPriceLoader.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation SPItemPriceLoader

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(SPItemPriceLoaderCompletion)completion
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://store.dota2.com.cn/itemdetails/11432"]];
    
    
    
}

@end
