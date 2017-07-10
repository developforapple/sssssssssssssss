//
//  YGPayThirdPlatformProcessor.m
//  Golf
//
//  Created by bo wang on 2016/12/5.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "YGPayThirdPlatformProcessor.h"

#if AlipaySDK_Enabled
    #import <AlipaySDK/AlipaySDK.h>
#endif

#if UPPaySDK_Enabled
    #import "UPPaymentControl.h"
#endif

#if ApplePaySDK_Enabled
    #import "UPAPayPlugin.h"
    #import "UPAPayPluginDelegate.h"
#endif

#if WechatSDK_Enabled
    #import "WXApi.h"
#endif

#if PingppSDK_Enabled
    #import "Pingpp.h"
#endif

#import "YGPaymentResult.h"

//static NSString *const kYGMerchantIdentifier = @"TODO";

static NSString *const kYGPayAlipayNotification = @"ALiPayCallBack";
static NSString *const kYGPayWechatNotification = @"WXCallBack";
static NSString *const kYGPayUnionPayNotification = @"UPPayCallback";//unionpayCallback
static NSString *const kYGPayApplePayNotification = @"ApplePayCallback";

static NSString *const kYGPayPingppNotification = @"PingppCallback";
static NSString *const kYGPayPingppPlatformInfoKey = @"PingppPlatformInfoKey";

@interface YGPayThirdPlatformProcessor ()
//<UPAPayPluginDelegate>
@end

@implementation YGPayThirdPlatformProcessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_alipayCallback:) name:kYGPayAlipayNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_wechatCallback:) name:kYGPayWechatNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_uppayCallback:) name:kYGPayUnionPayNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applePayCallback:) name:kYGPayApplePayNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pingppCallback:) name:kYGPayPingppNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIViewController *)viewCtrl
{
    if (!_viewCtrl) {
        return [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return _viewCtrl;
}

- (void)_alipayCallback:(__unused NSNotification *)noti
{
    NSDictionary *result = noti.object;
    [self handlePayResult:result platform:YGPayThirdPlatformAlipay];
}

- (void)_wechatCallback:(__unused NSNotification *)noti
{
    PayResp *resp = noti.object;
    [self handlePayResult:resp platform:YGPayThirdPlatformWechat];
}

- (void)_uppayCallback:(__unused NSNotification *)noti
{
#if UPPaySDK_Enabled
    NSString *code = noti.object;
    [self handlePayResult:code platform:YGPayThirdPlatformUPPay];
#endif
}

- (void)_applePayCallback:(__unused NSNotification *)noti
{
#if UPPaySDK_Enabled
    UPPayResult *result = noti.object;
    [self handlePayResult:result platform:YGPayThirdPlatformApplePay];
#endif
}

- (void)_pingppCallback:(__unused NSNotification *)noti
{
#if PingppSDK_Enabled
    YGPaymentResult *theResult = noti.object;
    YGPayThirdPlatform platform = [noti.userInfo[kYGPayPingppPlatformInfoKey] integerValue];
    if ([self.receiver respondsToSelector:@selector(didReceivedThirdPayPlatformResult:platform:)]) {
        [self.receiver didReceivedThirdPayPlatformResult:theResult platform:platform];
    }
#endif
}

- (void)handlePayResult:(id)result platform:(YGPayThirdPlatform)platform
{
    YGPaymentResult *theResult;
    switch (platform) {
        case YGPayThirdPlatformWechat:{
            theResult = [YGPaymentResult wechatResult:result];
        }   break;
        case YGPayThirdPlatformAlipay:{
            theResult = [YGPaymentResult alipayResult:result];
        }   break;
        case YGPayThirdPlatformUPPay:{
#if UPPaySDK_Enabled
            theResult = [YGPaymentResult unionpayResult:result];
#endif
        }   break;
        case YGPayThirdPlatformApplePay:{
#if ApplePaySDK_Enabled
            theResult = [YGPaymentResult applepayResult:result];
#endif
        }   break;
    }
    
    if ([self.receiver respondsToSelector:@selector(didReceivedThirdPayPlatformResult:platform:)]) {
        [self.receiver didReceivedThirdPayPlatformResult:theResult platform:platform];
    }
}

- (void)pay:(id)payInfo platform:(YGPayThirdPlatform)platform
{
    switch (platform) {
        case YGPayThirdPlatformWechat:{
            NSDictionary *info = payInfo;
            if (!info || ![info isKindOfClass:[NSDictionary class]]) {
                return;
            }
#if PingppSDK_Enabled
            // 使用Pingpp调起支付
            [Pingpp createPayment:info appURLScheme:kWechatScheme withCompletion:[YGPayThirdPlatformProcessor pingppCompletion:YGPayThirdPlatformWechat]];
#elif WechatSDK_Enabled
            // 使用微信原始SDK调起支付
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = info[@"partnerid"];
            req.prepayId = info[@"prepayid"];
            req.package = info[@"package"];
            req.nonceStr = info[@"noncestr"];
            req.timeStamp = (UInt32)[info[@"timestamp"] integerValue];
            req.sign = info[@"sign"];
            [WXApi sendReq:req];
#endif
            
        }   break;
        case YGPayThirdPlatformAlipay:{
            
#if PingppSDK_Enabled
            // 用户未安装支付宝的情况下将仅仅通过 completion 返回
            [Pingpp createPayment:payInfo appURLScheme:kAlipayScheme withCompletion:[YGPayThirdPlatformProcessor pingppCompletion:YGPayThirdPlatformAlipay]];
#elif AlipaySDK_Enabled
            NSString *info = payInfo;
            if (!info || ![info isKindOfClass:[NSString class]]) {
                return;
            }
            NSString *xml = [info stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            [[AlipaySDK defaultService] payOrder:xml fromScheme:kAlipayScheme callback:^(NSDictionary *resultDic) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayAlipayNotification object:resultDic userInfo:nil];
            }];
#endif
            
        }   break;
        case YGPayThirdPlatformUPPay:{
#if UPPaySDK_Enabled
            NSString *info = payInfo;
            if (!info || ![info isKindOfClass:[NSString class]]) return;
            
#if DEBUG_MODE
            [[UPPaymentControl defaultControl] startPay:info fromScheme:kUnionPayScheme mode:@"01" viewController:self.viewCtrl];
#else
            [[UPPaymentControl defaultControl] startPay:info fromScheme:kUnionPayScheme mode:@"00" viewController:self.viewCtrl];
#endif
        
#endif
        }   break;
        case YGPayThirdPlatformApplePay:{
#if ApplePaySDK_Enabled
            //TEST
//            NSURL* url = [NSURL URLWithString:@"http://101.231.204.84:8091/sim/getacptn"];
//            NSString *xml = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            //TEST
//            NSString *xml = self.payment.payModel.payXML;
//            if ([xml isKindOfClass:[NSString class]]) {
//                [UPAPayPlugin startPay:xml mode:kDebugMode?@"01":@"00" viewController:self.viewCtrl delegate:self andAPMechantID:kYGMerchantIdentifier];
//            }
#endif
        }   break;
    }
}

- (void)UPAPayPluginResult:(UPPayResult *) payResult
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayApplePayNotification object:payResult userInfo:nil];
}

+ (BOOL)canHandleURL:(NSURL *)URL
{
    NSString *scheme = URL.scheme;
    return
    [scheme isEqualToString:kAlipayScheme] ||
    [scheme isEqualToString:kUnionPayScheme];
}

+ (BOOL)handleOpenURL:(NSURL *)URL
{
    NSString *scheme = URL.scheme;
    if ([scheme isEqualToString:kAlipayScheme]) {
        
#if PingppSDK_Enabled
        // 这里只是告知Pingpp支付结果，仍然使用原始SDK处理结果，
        [Pingpp handleOpenURL:URL withCompletion:[self pingppCompletion:YGPayThirdPlatformAlipay]];
#elif AlipaySDK_Enabled
        [[AlipaySDK defaultService] processOrderWithPaymentResult:URL standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayAlipayNotification object:resultDic userInfo:nil];
        }];
#endif
        
        return YES;
    }else if ([scheme isEqualToString:kUnionPayScheme]){
#if UPPaySDK_Enabled
        [[UPPaymentControl defaultControl] handlePaymentResult:URL completeBlock:^(NSString *code, NSDictionary *data) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayUnionPayNotification object:code userInfo:data];
            
        }];
#endif
        return YES;
    }else{
        return NO;
    }
}

#if WechatSDK_Enabled
+ (void)handleWechatResp:(PayResp *)resp
{
    if (!resp || ![resp isKindOfClass:[PayResp class]]) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayWechatNotification object:resp userInfo:nil];
}
#endif

#if PingppSDK_Enabled
+ (PingppCompletion)pingppCompletion:(YGPayThirdPlatform)platform
{
    return ^(NSString *result, PingppError *error){
        YGPaymentResult *paymentResult = [YGPaymentResult pingppResult:result error:error];
        [[NSNotificationCenter defaultCenter] postNotificationName:kYGPayPingppNotification
                                                            object:paymentResult
                                                          userInfo:@{kYGPayPingppPlatformInfoKey:@(platform)}];
    };
}

#endif

@end
