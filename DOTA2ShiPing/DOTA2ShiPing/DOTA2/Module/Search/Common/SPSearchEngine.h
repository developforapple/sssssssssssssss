//
//  SPSearchEngine.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPSearchCommon.h"

@class SPItem;
@class SPPlayer;

/**
 *  App内置搜索引擎
 */
@interface SPSearchEngine : SPObject

- (instancetype)initWithType:(SPSearchType)type;

@property (assign, readonly, nonatomic) SPSearchType type;

#pragma mark - Items
/**
 *  根据keyward搜索相关的饰品名称。关键词以英文字母开头的推荐英文名，否则推荐中文名。
 *
 *  @param keyward 关键词
 *  @param limit   最大推荐数量。
 *
 *  @return 返回nil,本次搜索出错或者被取消。否则，返回搜索结果，结果可能为空。
 */
- (NSArray<NSString *> *)searchItemNamesWithKeyward:(NSString *)keyword
                                              limit:(NSUInteger)limit;

/**
 *  饰品名称搜索历史。
 *
 *  @return
 */
- (NSArray<NSString *> *)itemNamesSearchHistory;
/**
 *  记录下一条搜索记录
 *
 *  @param keyword
 */
- (void)recordItemNameSearchKeyword:(NSString *)keyword;

#pragma mark - User
/**
 *  根据关键词搜索用户。关键词可以是用户名和steamid
 *
 *  @param keyword    关键词
 *  @param completion 回调
 */
- (void)searchUserWithKeyword:(NSString *)keyword
                   completion:(void (^)(BOOL suc, NSArray<SPPlayer *> *users))completion;

@end
