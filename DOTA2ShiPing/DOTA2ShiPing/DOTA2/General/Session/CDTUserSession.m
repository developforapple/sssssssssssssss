//
//  CDTUserSession.m
//  CDT
//
//  Created by wwwbbat on 2017/5/22.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "CDTUserSession.h"
#import "WXApi.h"
#import "CDTLoginViewCtrl.h"
#import "ReactiveObjC.h"
#import "AFNetworking.h"
#import "CDTWechatAuthToken.h"
#import "CDTWechatUser.h"
#import "UIDevice+FCUUID.h"
#import "CDTUser.h"
#import "CDTAppDelegate.h"

#define WechatAPI [[CDTUserSession session] wechatAPI]

@interface CDTUserSession ()

@property (strong, nonatomic) AFHTTPSessionManager *wechatAPI;
@property (copy, nonatomic) NSString *authReqState;
@property (strong, nonatomic) SendAuthResp *wechatAuthResp;
@property (strong, nonatomic) CDTWechatAuthToken *wechatAuthToken;
@property (strong, nonatomic) CDTWechatUser *wechatUser;

@property (assign, readwrite, nonatomic) BOOL logined;
@property (strong, readwrite, nonatomic) CDTUser *user;

@property (copy, nonatomic) void (^wechatLoginCompletion)(void);
@property (copy, nonatomic) void (^lastTask)(BOOL suc);

@end

@implementation CDTUserSession

+ (instancetype)session
{
    static CDTUserSession *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [CDTUserSession new];
        
        AFHTTPSessionManager *wechatAPI = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.weixin.qq.com"]];
        wechatAPI.requestSerializer.timeoutInterval = 30.f;
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:wechatAPI.responseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/plain"];
        wechatAPI.responseSerializer.acceptableContentTypes = acceptableContentTypes;
        session.wechatAPI = wechatAPI;
        
        session.user = [session cachedMe];
        session.logined = session.user.accessToken.length > 0;
    });
    return session;
}

- (void)checkAccessTokenValid:(NSInteger)apiResult
{
    if (!self.logined) return;
    
    if (apiResult == -2) {
        [self logout];
        [UIAlertController alert:@"已在别处登录" message:nil callback:^{
            UINavigationController *vc = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if ([vc isKindOfClass:[UINavigationController class]]) {
                [vc popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)logined:(CDTUser *)user
{
    self.user = user;
    self.logined = user.accessToken.length > 0;
    [APPDELEGATE uploadPushToken];
}

- (NSString *)accessToken
{
    return self.user.accessToken;
}

#pragma mark - Login

- (void)loginIfNeed:(UIViewController *)from
        doSomething:(void(^)(void))block
{
    if (self.logined) {
        block?block():0;
    }else{
        // 手动登录
        [self askUserLogin:^(BOOL suc) {
            if (suc && block) {
                block();
            }
        } from:from];
    }
}

- (void)askUserLogin:(void(^)(BOOL suc))completion from:(UIViewController *)vc
{
    vc = vc?:[UIApplication sharedApplication].delegate.window.rootViewController;
    CDTLoginNaviCtrl *loginNavi = [CDTLoginNaviCtrl instanceFromStoryboard];
    self.lastTask = completion;
    [vc presentViewController:loginNavi animated:YES completion:nil];
}

- (void)login:(NSString *)mobile
         code:(NSString *)code
   completion:(void (^)(DDResponse *resp))completion
{
    [API login:mobile code:code uuid:[[UIDevice currentDevice] uuid] success:^(DDTASK task, DDResponse *resp) {
        
        NSDictionary *userInfo = resp.data[@"user"];
        CDTUser *user = [CDTUser yy_modelWithJSON:userInfo];
        
        [self loginCompleted:user];
        
        if (completion) {
            completion(resp);
        }
    } failure:^(DDTASK task, DDResponse *resp) {
        if (completion) {
            completion(resp);
        }
    }];
}

#pragma mark - Wechat Login

// 开始微信授权
- (void)launchWechatAuth:(void (^)(void))completion
{
    self.wechatLoginCompletion = completion;
    
    uint32_t state = arc4random_uniform(UINT32_MAX-10);
    self.authReqState = [@(state) stringValue];
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = self.authReqState;
    [WXApi sendReq:req];
}

// 收到微信授权
- (void)didReceivedWechatAuthResp:(SendAuthResp *)resp
{
    if (!resp || ![resp isKindOfClass:[SendAuthResp class]]) return;
    if (self.authReqState && ![resp.state isEqualToString:self.authReqState]) return;
    
    NSString *code = resp.code;
    if (code.length == 0) return;
    
    self.wechatAuthResp = resp;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = kWechatAppID;
    params[@"secret"] = kWechatAppSecret;
    params[@"code"] = code;
    params[@"grant_type"] = @"authorization_code";
    
    [SVProgressHUD show];
    
    [WechatAPI POST:@"sns/oauth2/access_token" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        CDTWechatAuthToken *token = [CDTWechatAuthToken yy_modelWithJSON:responseObject];
        self.wechatAuthToken = token;
        
        if (token.access_token.length == 0) {
            [SVProgressHUD showErrorWithStatus:token.errmsg?:@"微信登录异常，请重试"];
        }else{
            [self refreshWechatUserInfo];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

// 请求微信登录用户信息
- (void)refreshWechatUserInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = self.wechatAuthToken.access_token;
    params[@"openid"] = self.wechatAuthToken.openid;
    
    [WechatAPI POST:@"sns/userinfo" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        CDTWechatUser *wechatUser = [CDTWechatUser yy_modelWithJSON:responseObject];
        self.wechatUser = wechatUser;
        if (wechatUser.errmsg) {
            [SVProgressHUD showErrorWithStatus:wechatUser.errmsg?:@"微信登录异常，请重试"];
        }else{
            [self loginUsing3rdParty];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

// 使用微信登录用户信息登录app
- (void)loginUsing3rdParty
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"wxCode"]                = self.wechatAuthResp.code;
    param[@"accessToken3Party"]     = self.wechatAuthToken.access_token;
    param[@"refreshToken3Party"]    = self.wechatAuthToken.refresh_token;
    param[@"openId"]                = self.wechatAuthToken.openid;
    param[@"headImage"]             = self.wechatUser.headimgurl;
    param[@"nickName"]              = self.wechatUser.nickname;
    param[@"sex"]                   = @(self.wechatUser.sex);
    param[@"loginType"]             = @1;
    param[@"wxUnionId"]             = self.wechatUser.unionid;
    param[@"uuId"]                  = [[UIDevice currentDevice] uuid];
    
    [API loginUsingWechat:param success:^(DDTASK task, DDResponse *resp) {
        
        [SVProgressHUD dismiss];
        
        NSString *access_token = resp.data[@"access_token"];
        NSDictionary *userInfo = resp.data[@"user"];
        CDTUser *user = [CDTUser yy_modelWithJSON:userInfo];
        user.accessToken = access_token;
        
        [self loginCompleted:user];
        
    } failure:^(DDTASK task, DDResponse *resp) {
        [SVProgressHUD showErrorWithStatus:resp.error.msg];
    }];
}

- (void)updateUserInfo:(CDTUser *)user
{
    if (!user) return;
    self.user = user;
    self.logined = user.accessToken.length > 0;
    [self saveMe:user];
}

- (void)loginCompleted:(CDTUser *)user
{
    [self updateUserInfo:user];
    
    if (self.wechatLoginCompletion) {
        self.wechatLoginCompletion();
        self.wechatLoginCompletion = nil;
    }
    
    if (self.lastTask) {
        self.lastTask(self.logined);
        self.lastTask = nil;
    }
}

#pragma mark - 登出
- (void)logout
{
    self.user = nil;
    self.logined = NO;
    self.authReqState = nil;
    self.wechatUser = nil;
    self.wechatAuthResp = nil;
    self.wechatAuthToken = nil;
    self.wechatLoginCompletion = nil;
    self.lastTask = nil;
    [self removeMe];
}

@end

#pragma mark - Cache

#if DEBUG_MODE
static NSString *kCachedUserInfoKey = @"cn.laidian.CDT.test";
#else
static NSString *kCachedUserInfoKey = @"cn.laidian.CDT.UserSession";
#endif

@implementation CDTUserSession (Cache)
- (CDTUser *)cachedMe
{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kCachedUserInfoKey];
    if (!data) return nil;
    CDTUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

- (void)saveMe:(CDTUser *)user
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCachedUserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeMe
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCachedUserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
