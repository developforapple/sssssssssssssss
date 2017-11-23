//
//  SPPlayerItemQuery.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemQuery.h"
#import "SPDataManager.h"

@import FMDB;

@implementation SPPlayerItemQuery

+ (instancetype)queryWithPlayerItems:(NSArray<SPPlayerItemDetail *> *)playerItems
{
    SPPlayerItemQuery *query = [[self alloc] init];
    query.tokens = [playerItems valueForKeyPath:@"defindex"];
    return query;
}

- (BOOL)updateItems
{
    SPDBWITHOPEN
    
    AsyncBenchmarkTestBegin(SPPlayerItemQuery);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *token in self.orderedTokens) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM items WHERE token = %@;",token];
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSDictionary *dict = resultSet.resultDictionary;
            SPItem *item = [SPItem yy_modelWithDictionary:dict];
            if (item) {
                [result addObject:item];
            }
        }
        [resultSet close];
    }
    
    AsyncBenchmarkTestEnd(SPPlayerItemQuery);
    
    SPDBCLOSE
    
    self.items = result;
    self.fullItems = @[result];
    self.fullTitles = @[@""];
    return YES;
}

- (void)separateItem
{
    
}

@end
