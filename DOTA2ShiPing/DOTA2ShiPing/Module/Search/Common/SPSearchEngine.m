//
//  SPSearchEngine.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSearchEngine.h"
#import "SPDataManager.h"
#import "SPItem.h"
#import "YYCache.h"
#import "SPMaxPlusAPI.h"
#import "SPDotabuffAPI.h"
#import "SPSteamAPI.h"
#import "SPPlayer.h"

static NSString *const kItemNamesKey = @"names";
static NSString *const kUsersKey = @"users";

@interface SPSearchEngine ()
@property (strong, nonatomic) YYCache *itemNamesHistory;
@property (strong, nonatomic) YYCache *userHistory;
@end

@implementation SPSearchEngine

- (instancetype)initWithType:(SPSearchType)type
{
    self = [super init];
    if (self) {
        self->_type = type;
        [self setupCache];
    }
    return self;
}

- (void)setupCache
{
    switch (self.type) {
        case SPSearchTypeItemName:{
            self.itemNamesHistory = [YYCache cacheWithName:@"itemNameSearchHistoryCache"];
        }    break;
        case SPSearchTypeMaxPlusPlayer:{
            self.userHistory = [YYCache cacheWithName:@"userSearchHistoryCache"];
        }    break;
        case SPSearchTypeSteamCommunityPlayer:{
            self.userHistory = [YYCache cacheWithName:@"TODO"];
        }   break;
        default:
            break;
    }
}

#pragma mark - Items
- (NSArray<NSString *> *)searchItemNamesWithKeyward:(NSString *)keyward limit:(NSUInteger)limit
{
    if (keyward.length == 0) {
        return nil;
    }
    
//    // lo
//    static NSTimeInterval minimumInterval = .2f;    //最小搜索间隔
//    static BOOL locker = NO;
//    if (locker) {
//        return nil;
//    }
//    locker = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(minimumInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        locker = NO;
//    });
    
    static NSString *words = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *prefix = [keyward substringToIndex:1];
    BOOL isEnglish = [words containsString:prefix]; //iOS8

    NSString *column = isEnglish?@"name":@"item_name";
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM items WHERE %@ LIKE ? LIMIT 0,%lu;",column,column,(unsigned long)limit];
    NSArray *params = @[[NSString stringWithFormat:@"%%%@%%",keyward]];
    
    NSError *error;
    FMResultSet *result = [[SPDataManager shared].db executeQuery:sql values:params error:&error];
    if (error) {
        [result close];
        NSLog(@"%@",error);
        return nil;
    }
    
    int columnIndex = [result columnIndexForName:column];
    
    NSMutableArray *strings = [NSMutableArray array];
    while ([result next]) {
        [strings addObject:[result stringForColumnIndex:columnIndex]];
    }
    [result close];
    return strings;
}

- (NSArray<NSString *> *)itemNamesSearchHistory
{
    NSArray *names = (NSArray *)[self.itemNamesHistory objectForKey:kItemNamesKey];
    return names;
}

- (void)recordItemNameSearchKeyword:(NSString *)keyword
{
    if (keyword.length == 0 ) {
        return;
    }
    NSMutableArray *names = [NSMutableArray arrayWithArray:[self itemNamesSearchHistory]];
    if ([names containsObject:keyword]) {
        [names removeObject:keyword];
    }
    [names insertObject:keyword atIndex:0];
    [self.itemNamesHistory setObject:names forKey:kItemNamesKey];
}

#pragma mark - Users
- (void)searchUserWithKeyword:(NSString *)keyword
                   completion:(void (^)(BOOL suc, NSArray<SPPlayer *> *users))completion
{
    switch (self.type) {
        case SPSearchTypeMaxPlusPlayer:{
            [[SPMaxPlusAPI shared] searchUser:keyword completion:^(BOOL suc, NSArray *list, NSString *msg) {
                NSArray *users = [NSArray yy_modelArrayWithClass:[SPPlayer class] json:list];
                if (completion) {
                    completion(suc,users);
                }
            }];
        }   break;
        case SPSearchTypeDotabuffPlayer:{
            [SPDotabuffAPI searchUser:keyword completion:^(BOOL suc, NSArray *list, NSString *msg) {
                if (completion) {
                    completion(suc,list);
                }
            }];
        }   break;
        case SPSearchTypeSteamCommunityPlayer:{
            [[SPSteamAPI shared] searchUser:keyword completion:^(BOOL suc, NSArray *list, NSString *msg) {
                if (completion) {
                    completion(suc,list);
                }
            }];
        }   break;
        case SPSearchTypeItemName:break;
    }
}

@end
