//
//  SPStarManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPStarManager.h"

@import FMDB;

@interface SPStarManager ()
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation SPStarManager

+ (instancetype)manager
{
    static SPStarManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPStarManager new];
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
    NSString *dbFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".spzh.star.v1"];
    if (![fm fileExistsAtPath:dbFolder]) {
        [fm createDirectoryAtPath:dbFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath = [dbFolder stringByAppendingPathComponent:@"history.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS star (  token text PRIMARY KEY,\
                                                           orderid integer)"];
    [db close];
    return db;
}

- (NSArray<NSString *> *)getRecord:(NSInteger)orderId
                          pageSize:(int)pageSize
{
    [self.db open];
    
    NSString *sql;
    if (orderId == 0) {
        sql = [NSString stringWithFormat:@"SELECT token FROM star ORDER BY orderid DESC LIMIT %d",MAX(0, pageSize)];
    }else{
        sql = [NSString stringWithFormat:@"SELECT token FROM star WHERE orderid < %ld ORDER BY orderid DESC LIMIT %d",orderId,MAX(0, pageSize)];
    }
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [self.db executeQuery:sql];
    int tokenIndex = [result columnIndexForName:@"token"];
    while ([result next]) {
        NSString *token = [result stringForColumnIndex:tokenIndex];
        [array addObject:token];
    }
    [self.db close];
    return array;
}

- (void)add:(NSString *)token
{
    [self.db open];
    
    long long maxId = 0;
    FMResultSet *maxOrderIdSet = [self.db executeQuery:@"SELECT MAX(orderid) FROM star"];
    if ([maxOrderIdSet next]) {
        maxId = [maxOrderIdSet longLongIntForColumn:@"orderid"];
    }
    
    long long orderid = maxId + 1;
    NSString *sql = @"INSERT OR REPLACE INTO star(token,orderid)VALUES(?,?)";
    BOOL result = [self.db executeUpdate:sql,token,@(orderid)];
    if (!result) {
        NSError *error = [self.db lastError];
        NSLog(@"%@",error);
    }
    [self.db close];
}

- (void)remove:(NSString *)token
{
    [self.db open];
    
    BOOL result = [self.db executeUpdate:@"DELETE FROM star WHERE token = ?",token];
    if (!result) {
        NSError *error = [self.db lastError];
        NSLog(@"%@",error);
    }
    [self.db close];
}

- (BOOL)isStarred:(NSString *)token
{
    [self.db open];
    FMResultSet *result = [self.db executeQuery:@"SELECT token FROM star WHERE token = ?",token];
    BOOL starred = [result next];
    [self.db close];
    return starred;
}

@end
