//
//  SPFilterConfig.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterConfig.h"

@implementation SPFilterConfig

+ (instancetype)defaultConfig
{
    SPFilterConfig *config = [SPFilterConfig new];
    
    config.allowsMultipleSelection = YES;
    config.allowsMultipleSelectionInSection = YES;
    
    return config;
}

@end
