//
//  YGThirdPlatformProcessor.m
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGThirdPlatformProcessor.h"
#import "YGPayThirdPlatformProcessor.h"
#import "CDTUserSession.h"

#if PingppSDK_Enabled
    #import "Pingpp.h"
#endif

#if WeiboSDK_Enabled
    #import <WeiboSDK.h>
#endif

#if WechatSDK_Enabled
    #import "WXApi.h"
#endif

#if QQSDK_Enabled  
    #import <TencentOpenAPI/QQApiInterface.h>
#endif

#if WeiboSDK_Enabled
    FOUNDATION_EXTERN NSString *const kWeiboScheme;       //在微博注册的scheme
#endif

#if WechatSDK_Enabled
    FOUNDATION_EXTERN NSString *const kWechatScheme;      //在微信注册的scheme
#endif

#if QQSDK_Enabled
    FOUNDATION_EXTERN NSString *const kQQScheme;          //在QQ注册的scheme
#endif

#if AlipaySDK_Enabled
    FOUNDATION_EXTERN NSString *const kAlipayScheme;      //支付宝
#endif

#if UPPaySDK_Enabled
    FOUNDATION_EXTERN NSString *const kUnionPayScheme;    //银联支付
#endif

@interface YGThirdPlatformProcessor ()@end

#if WeiboSDK_Enabled
@interface YGThirdPlatformProcessor (Weibo)<WeiboSDKDelegate>@end
@implementation YGThirdPlatformProcessor (Weibo)@end
#endif

#if WechatSDK_Enabled
@interface YGThirdPlatformProcessor (Wechat)<WXApiDelegate>@end
@implementation YGThirdPlatformProcessor (Wechat)@end
#endif

#if QQSDK_Enabled
@interface YGThirdPlatformProcessor (QQ)<QQApiInterfaceDelegate>@end
@implementation YGThirdPlatformProcessor (QQ)@end
#endif

@implementation YGThirdPlatformProcessor

+ (instancetype)processor
{
    static YGThirdPlatformProcessor *processor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processor = [YGThirdPlatformProcessor new];
    });
    return processor;
}

+ (BOOL)canHandleURL:(NSURL *)URL
{
#if WeiboSDK_Enabled
    if ([URL.scheme isEqualToString:kYGSchemeWeibo]) {
        return YES;
    }
#endif
    
#if WechatSDK_Enabled
    if ([URL.scheme isEqualToString:kWechatScheme]) {
        return YES;
    }
#endif

#if QQSDK_Enabled
    if ([URL.scheme isEqualToString:kQQScheme]) {
        return YES;
    }
#endif
    
    if ([YGPayThirdPlatformProcessor canHandleURL:URL]) {
        return YES;
    }
    return NO;
}

- (BOOL)handleURL:(NSURL *)URL
{
#if WeiboSDK_Enabled
    if ([URL.scheme isEqualToString:kYGSchemeWeibo]) {
        return [WeiboSDK handleOpenURL:URL delegate:self];
    }
#endif
    
#if WechatSDK_Enabled
    if ([URL.scheme isEqualToString:kWechatScheme]) {
        
        BOOL wechatHandled = NO;
    #if PingppSDK_Enabled
        wechatHandled = [Pingpp handleOpenURL:URL withCompletion:[YGPayThirdPlatformProcessor pingppCompletion:YGPayThirdPlatformWechat]];
    #endif
        if (!wechatHandled) {
            wechatHandled = [WXApi handleOpenURL:URL delegate:self];
        }
        return wechatHandled;
    }
#endif
    
#if QQSDK_Enabled
    if ([URL.scheme isEqualToString:kQQScheme]) {
        return [QQApiInterface handleOpenURL:URL delegate:self];
    }
#endif
    
    if ([YGPayThirdPlatformProcessor handleOpenURL:URL]) {
        return YES;
    }
    return NO;
}

#pragma mark - WeiboDelegate
#if WeiboSDK_Enabled
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{}
#endif //WeiboSDK_Enabled


#pragma mark - Wechat && QQ Delegate
#if WechatSDK_Enabled || QQSDK_Enabled

// QQ和微信的方法名是一样的
- (void)onResp:(id)resp
{
#if QQSDK_Enabled
    if ([resp isKindOfClass:[QQBaseReq class]]) {
        [self onResp_qq:(QQBaseResp *)resp];
        return;
    }
#endif

#if WechatSDK_Enabled
    [self onResp_wechat:resp];
#endif
    
}

#if WechatSDK_Enabled
- (void)onResp_wechat:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        [SESSION didReceivedWechatAuthResp:(SendAuthResp *)resp];
        
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSString *strMsg = nil;
        
        BOOL have = NO;
        switch (resp.errCode) {
            case 0:
                have = YES;
                strMsg = @"分享成功";
                break;
            case -1:
                have = NO;
                strMsg = @"分享失败";
                break;
            case -2:
                have = NO;
                strMsg = @"您已取消分享";
                break;
            case -3:
                have = NO;
                strMsg = @"分享失败";
                break;
            case -4:
                //strMsg = @"信息分享未取得授权";
                break;
            case -5:
                //strMsg = @"不支持分享功能";
                break;
                
            default:
                break;
        }
        
        if (strMsg) {
            if (have) {
                [SVProgressHUD showSuccessWithStatus:strMsg];
            }else{
                [SVProgressHUD showInfoWithStatus:strMsg];
            }
        }
    }else if ([resp isKindOfClass:[PayResp class]]){
        [YGPayThirdPlatformProcessor handleWechatResp:(PayResp *)resp];
    }
}
#endif

#if QQSDK_Enabled
- (void)onResp_qq:(QQBaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *sresp = (SendMessageToQQResp *)resp;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kQQSharedNotification object:nil userInfo:@{kQQSharedKey: sresp}];
        
    }
}
#endif

#endif //WechatSDK_Enabled || QQSDK_Enabled

@end
