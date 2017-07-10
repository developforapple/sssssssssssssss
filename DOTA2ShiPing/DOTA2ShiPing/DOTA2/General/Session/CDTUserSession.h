//
//  CDTUserSession.h
//  CDT
//
//  Created by wwwbbat on 2017/5/22.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;
#import "CDTUser.h"

@class SendAuthResp;

#define SESSION [CDTUserSession session]
#define ME [SESSION user]

@interface CDTUserSession : NSObject

+ (instancetype)session;

// 每个api接口都会返回result，根据result==-2来判断accessToken失效
- (void)checkAccessTokenValid:(NSInteger)apiResult;

// 当前用户是否登录
@property (assign, readonly, nonatomic) BOOL logined;
// 当前用户登录后的access_token
@property (copy, readonly, nonatomic) NSString *accessToken;
// 当前用户信息
@property (strong, readonly, nonatomic) CDTUser *user;

- (void)updateUserInfo:(CDTUser *)user;

// app不需要登录才能使用时使用此方法进行登录
// 如果未登录，则打开登录界面，登录后block回调。如果登录了，直接block回调。
- (void)loginIfNeed:(UIViewController *)from
        doSomething:(void(^)(void))block;


// 使用微信登录，登录成功后回调，失败或中断不回调
- (void)launchWechatAuth:(void (^)(void))completion;
// 处理微信回调的handle调用此方法通知session
- (void)didReceivedWechatAuthResp:(SendAuthResp *)resp;


// 使用手机登录，登录成功、失败、取消都回调
- (void)login:(NSString *)mobile
         code:(NSString *)code
   completion:(void (^)(DDResponse *resp))completion;


// 登出
- (void)logout;


@end

@interface CDTUserSession (Cache)
- (CDTUser *)cachedMe;
- (void)saveMe:(CDTUser *)user;
- (void)removeMe;
@end
