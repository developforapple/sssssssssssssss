//
//  SPSteamAPI.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//


#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class SPPlayerItemsList;

typedef void (^SPSteamSearchUserCompletion)(BOOL suc, NSArray *list, NSString *msg);
typedef void (^SPSteamFetchCompletion)(BOOL suc, id object);
typedef void (^SPSteamFetchCompletion2)(BOOL suc, id object, NSString *taskDesc);

@interface SPSteamAPI : SPObject

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

#pragma mark - Workshop
// 获取创意工坊内容
- (NSURLSessionDataTask *)fetchWorkShopContent:(NSDictionary *)query
                                      progress:(void (^)(NSProgress *progress))progress
                                    completion:(SPSteamFetchCompletion2)completion;
// 获取创意工坊详情
- (NSURLSessionDataTask *)fetchWorkshopDetail:(NSNumber *)itemid
                                   completion:(SPSteamFetchCompletion2)completion;
// 测试创意工坊资源图片 获取其大小
- (void)workshopImageTest:(NSURL *)imageURL
               completion:(void (^)(BOOL suc, NSUInteger size))completion;

#pragma mark - Steam Market

- (void)fetchSteamPriceOverview:(NSString *)itemName
                     completion:(SPSteamFetchCompletion2)completion;

- (void)fetchSteamPriceList:(NSString *)itemName
                     pageNo:(NSInteger)pageNo
                 completion:(SPSteamFetchCompletion2)completion;

- (NSURLSessionDataTask *)fetchSteamMarketContent:(NSString *)itemName
                                       completion:(SPSteamFetchCompletion2)completion;

- (void)fetchSteamMarketItemDetail:(NSString *)url
                        completion:(SPSteamFetchCompletion)completion;

@end



@interface SPLocation : SPObject
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *countryKEY;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *stateKey;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cityKey;
@end
