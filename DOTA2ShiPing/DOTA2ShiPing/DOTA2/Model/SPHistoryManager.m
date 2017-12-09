//
//  SPHistoryManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPHistoryManager.h"
@import FMDB;

@interface SPHistoryManager ()
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation SPHistoryManager

+ (instancetype)manager
{
    static SPHistoryManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPHistoryManager new];
    });
    return instance;
}

#pragma mark - db
- (FMDatabase *)db
{
    if (!_db) {
        _db = [self createDatabaseIfNeed];
        _db.traceExecution = YES;
    }
    return _db;
}

- (FMDatabase *)createDatabaseIfNeed
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dbFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".com.wwwbbat.sp.history"];
    if (![fm fileExistsAtPath:dbFolder]) {
        [fm createDirectoryAtPath:dbFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath = [dbFolder stringByAppendingPathComponent:@"history.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS history (  token text PRIMARY KEY,\
                                                              orderid integer default 0)"];
    [db close];
    return db;
}

- (NSArray<NSString *> *)getHistory:(NSInteger)orderId
                           pageSize:(int)pageSize
{
    [self.db open];
    
    NSString *sql;
    if (orderId == 0) {
        sql = [NSString stringWithFormat:@"SELECT token,orderid FROM history ORDER BY orderid DESC LIMIT %d",MAX(0, pageSize)];
    }else{
        sql = [NSString stringWithFormat:@"SELECT token,orderid FROM history WHERE orderid < %ld ORDER BY orderid DESC LIMIT %d",orderId,MAX(0, pageSize)];
    }
    NSMutableArray *orderids = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [self.db executeQuery:sql];
    int tokenIndex = [result columnIndexForName:@"token"];
    int orderidIndex = [result columnIndexForName:@"orderid"];
    while ([result next]) {
        NSString *token = [result stringForColumnIndex:tokenIndex];
        long long theOrderId = [result longLongIntForColumnIndex:orderidIndex];
        [array addObject:token];
        [orderids addObject:@(theOrderId)];
    }
    [self.db close];
    return array;
}

- (void)add:(NSString *)token
{
    [self.db open];
    
    long long maxId = 0;
    FMResultSet *maxOrderIdSet = [self.db executeQuery:@"SELECT MAX(orderid) FROM history"];
    if ([maxOrderIdSet next]) {
        id orderid = [maxOrderIdSet resultDictionary][@"MAX(orderid)"];
        if ([orderid respondsToSelector:@selector(longLongValue)]) {
            maxId = [orderid longLongValue];
        }
    }
    
    long long orderid = maxId + 1;
    NSString *sql = @"INSERT OR REPLACE INTO history(token,orderid)VALUES(?,?)";
    BOOL result = [self.db executeUpdate:sql,token,@(orderid)];
    if (!result) {
        NSError *error = [self.db lastError];
        SPLog(@"%@",error);
    }
    [self.db close];
}

@end
