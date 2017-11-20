//
//  SPGamepediaData.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaData.h"



@implementation SPGamepediaData

+ (instancetype)error:(NSError *)error
{
    SPGamepediaData *data = [SPGamepediaData new];
    data.error = error;
    return data;
}

@end
