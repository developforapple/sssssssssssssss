//
//  SPSteamAPI.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//


#import <Foundation/Foundation.h>

@class SPPlayerItemsList;

typedef void (^SPSteamSearchUserCompletion)(BOOL suc, NSArray *list, NSString *msg);
typedef void (^SPSteamFetchCompletion)(BOOL suc, id object);

@interface SPSteamAPI : NSObject

+ (instancetype)shared;
- (void)searchUser:(NSString *)keywords
        completion:(SPSteamSearchUserCompletion)completion;


#pragma mark - Inventory

// GetPlayerItems 接口获取饰品列表
- (void)fetchPlayerItems:(NSNumber *)steamid17
              completion:(void (^)(SPPlayerItemsList *list))completion;

/**
 *  获取用户的库存数据
 *  外部需要告知饰品总数为多少。否则不会有进度回调。
 *
 *  @param steamid17  steamid17
 *  @param count      饰品总数。如果为0或者nil，不会有进度回调。
 *  @param p          进度回调
 *  @param completion 结束回调
 */
- (void)fetchPlayerInventory:(NSNumber *)steamid17
                  itemsCount:(NSNumber *)count
                    progress:(void (^)(NSProgress *progress))p
                  completion:(SPSteamFetchCompletion)completion;

// 获取用户详细信息
- (void)fetchPlayerSummarie:(NSNumber *)steamid17
                  completion:(SPSteamFetchCompletion)completion;
// 批量获取用户详细信息
- (void)fetchPlayerSummaries:(NSArray *)steamid17s
                  completion:(SPSteamFetchCompletion)completion;

// 获取用户的曾用名
- (void)fetchPlayerAliases:(NSNumber *)steamid17
                completion:(SPSteamFetchCompletion)completion;

// 获取用户的好友列表
- (void)fetchPlayerFriends:(NSNumber *)steamid17
                completion:(SPSteamFetchCompletion)completion;

@end



@interface SPLocation : NSObject
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *countryKEY;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateKey;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cityKey;
@end
