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

@interface SPPlayerItemQuery ()

// 默认是全部库存物品
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *filteredPlayerItems;

@end

@implementation SPPlayerItemQuery

+ (instancetype)queryWithPlayerItems:(SPPlayerItemSharedData *)data
{
    SPPlayerItemQuery *query = [[self alloc] init];
    query.playerItemData = data;
    query.filteredPlayerItems = data.inventory.items;
    return query;
}

- (NSArray<SPItem *> *)loadPage:(NSInteger)page
{
    static NSInteger perPage = 100;
    
    NSInteger total = self.filteredPlayerItems.count;
    NSInteger loc = page * perPage;
    if (loc >= total) return nil;
    NSInteger len = (loc + perPage) > total ? (total - loc) : perPage ;
    
    NSArray<SPPlayerItemDetail *> *pagePlayerItems = [self.filteredPlayerItems subarrayWithRange:NSMakeRange(loc, len)];
    NSArray<NSNumber *> *tokens = [pagePlayerItems valueForKeyPath:@"defindex"];
    NSArray<SPItem *> *items = [self queryItems:tokens];
    self.pageNo = page;
    return items;
}

- (NSArray<SPItem *> *)queryItems:(NSArray<NSNumber *> *)tokens
{
    SPDBWITHOPEN
    
    AsyncBenchmarkTestBegin(SPPlayerItemQuery);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *token in tokens) {
        
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
    
    return result;
}

- (void)filter:(id)options
{
    self.options = options;
    if (options) {
        self.filteredPlayerItems = [self excuteFilter];
    }else{
        self.filteredPlayerItems = self.playerItemData.inventory.items;
    }
    self.pageNo = 0;
}

- (NSArray<SPPlayerItemDetail *> *)excuteFilter
{
    return nil;
}

@end
