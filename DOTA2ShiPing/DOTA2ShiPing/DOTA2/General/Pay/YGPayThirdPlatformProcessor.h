//
//  YGPayThirdPlatformProcessor.h
//  Golf
//
//  Created by bo wang on 2016/12/5.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import Foundation;
#import "YGPayThirdPlatform.h"
#import "YGPaymentResult.h"
#include "Config_ThirdParty.h"

#if PingppSDK_Enabled
    #import "Pingpp.h"
#endif

@class PayResp;
@class YGPaymentResult;

@protocol YGPayProcess <NSObject>
@required
- (void)didReceivedThirdPayPlatformResult:(YGPaymentResult *)result platform:(YGPayThirdPlatform)platform;
@end

@interface YGPayThirdPlatformProcessor : NSObject

@property (weak, nonatomic) id<YGPayProcess> receiver;
@property (weak, nonatomic) UIViewController *viewCtrl;

// 调起第三方支付。payInfo为服务端返回的支付信息
// 当服务端使用Ping++时，payInfo应当为json字符串。
// 当服务端不适用Ping++时，payInfo为各平台的支付信息
- (void)pay:(id)payInfo platform:(YGPayThirdPlatform)platform;

+ (BOOL)canHandleURL:(NSURL *)URL;
// 处理支付宝支付和银联支付
+ (BOOL)handleOpenURL:(NSURL *)URL;

#if WechatSDK_Enabled
// 处理微信支付
+ (void)handleWechatResp:(PayResp *)resp;
#endif

#if PingppSDK_Enabled
+ (PingppCompletion)pingppCompletion:(YGPayThirdPlatform)platform;
#endif

@end
