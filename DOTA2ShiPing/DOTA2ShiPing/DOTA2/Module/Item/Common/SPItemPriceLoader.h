//
//  SPItemPriceLoader.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPItem;

typedef void (^SPItemPriceLoaderCompletion)(float price);

@interface SPItemPriceLoader : NSObject

+ (void)loadDota2MarketPrice:(SPItem *)item
                  completion:(SPItemPriceLoaderCompletion)completion;

@end
