//
//  SPPlayerItemQuery.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemQuery.h"

#import "SPPlayerItems.h"

@interface SPPlayerItemQuery : SPItemQuery

+ (instancetype)queryWithPlayerItems:(NSArray<SPPlayerItemDetail *> *)playerItems;

@property (strong, nonatomic) NSArray<NSNumber *> *tokens;

@end
