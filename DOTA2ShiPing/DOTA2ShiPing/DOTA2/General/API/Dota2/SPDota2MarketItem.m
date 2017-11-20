//
//  SPDota2MarketItem.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPDota2MarketItem.h"

static SPDota2MarketItem *curItem;
static NSTimeInterval lastUpdate = 0;
static NSString *saveKey = @"sp_config_dota2_special_price_item";

@implementation SPDota2MarketItem

+ (BOOL)needUpdate
{
    if (lastUpdate == 0) {
        return YES;
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - lastUpdate;
    if (time > 10 * 60) {
        return YES;
    }
    return NO;
}

+ (instancetype)curItem
{
    if (!curItem) {
        curItem = [self savedItem];
    }
    return curItem;
}

+ (instancetype)savedItem
{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:saveKey];
    SPDota2MarketItem *item = [SPDota2MarketItem yy_modelWithJSON:data];
    return item;
}

- (void)save
{
    curItem = self;
    
    lastUpdate = [[NSDate date] timeIntervalSince1970];
    NSData *data = [self yy_modelToJSONData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:saveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

YYModelDefaultCode

@end
