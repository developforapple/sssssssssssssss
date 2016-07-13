//
//  SPPlayerManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlayer.h"

@interface SPPlayerManager : NSObject

+ (instancetype)shared;

@end

#pragma mark - Star
@interface SPPlayerManager (Star)
// 所有的星标用户
- (NSArray<SPPlayer *> *)starredPlayers;
// steamid是否在收藏列表
- (BOOL)isStarred:(NSNumber *)steamid;
// 星标用户列表发生更新时的回调
- (void)setStarredUpdatedCallback:(void (^)(void))callback;
// 取消星标
- (void)unstarPlayer:(NSNumber *)steamid;
// 增加星标。只操作已有记录的用户
- (void)starPlayer:(SPPlayer *)player;

@end

typedef void(^SPCompletion)(BOOL suc, NSString *msg);

@interface SPPlayerManager (Inventory)

// 为一个用户的饰品列表设定一个特征值。
// 下次获取到饰品列表时计算特征值，与旧值相比较，不一致时代表饰品列表已过期
// 特征值一般为获取饰品列表时服务器响应头中返回的数据长度
- (void)setItemsEigenvalue:(NSNumber *)value forPlayer:(NSNumber *)steamid;
- (NSNumber *)itemsEigenvalueOfPlayer:(NSNumber *)steamid;

// 库存数据更新日期。返回nil表示没有数据
- (NSDate *)archivedPlayerInventoryUpdateDate:(SPPlayer *)player;

// 读取
- (void)readArchivedPlayerInventory:(SPPlayer *)player;
// 保存
- (void)saveArchivedPlayerInventory:(SPPlayer *)player;

@end

@interface SPPlayerManager (Update)

@property (assign, readonly, nonatomic) BOOL check

@end