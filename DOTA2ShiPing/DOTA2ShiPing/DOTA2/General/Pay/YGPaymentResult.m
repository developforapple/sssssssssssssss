//
//  YGPaymentResult.m
//  Golf
//
//  Created by bo wang on 2016/10/27.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "YGPaymentResult.h"
//#import "UPAPayPluginDelegate.h"

#if WechatSDK_Enabled
    #import "WXApi.h"
#endif

#if PingppSDK_Enabled
    #import "Pingpp.h"
#endif

@implementation YGPaymentResult

+ (instancetype)wechatResult:(BaseResp *)resp
{
#if WechatSDK_Enabled
    if (!resp || ![resp isKindOfClass:[BaseResp class]])  return nil;
    
    YGPaymentResult *result = [YGPaymentResult new];
    result.originData = resp;
    result.sessionId = nil;//SESSION.token;
    
    if (resp.errCode == WXSuccess) {
        result.status = YGPayStatusSuccess;
    }else if (resp.errCode == WXErrCodeUserCancel){
        result.status = YGPayStatusCanceled;
    }else{
        result.status = YGPayStatusFailed;
    }
    return result;
#else
    return nil;
#endif
}

+ (instancetype)alipayResult:(NSDictionary *)resultDic
{
#if AlipaySDK_Enabled
    YGPaymentResult *result = [YGPaymentResult new];
    result.originData = resultDic;
    result.sessionId = nil;// SESSION.token;
    
    NSInteger alipayStatus = [resultDic[@"resultStatus"] integerValue];
    if (alipayStatus == AlipayStatusSuccess) {
        result.status = YGPayStatusSuccess;
    }else if (alipayStatus == AlipayStatusFailed ||
              alipayStatus == AlipayStatusNetworkErr){
        result.status = YGPayStatusFailed;
    }else if (alipayStatus == AlipayStatusCanceled){
        result.status = YGPayStatusCanceled;
    }
    return result;
#else
    return nil;
#endif
}

+ (instancetype)unionpayResult:(NSString *)resultStr
{
    YGPaymentResult *result = [YGPaymentResult new];
    result.originData = resultStr;
    result.sessionId = nil;//SESSION.token;
    
    if ([resultStr isEqualToString:@"success"]) {
        result.status = YGPayStatusSuccess;
    }else if ([resultStr isEqualToString:@"cancel"]){
        result.status = YGPayStatusCanceled;
    }else if([resultStr isEqualToString:@"fail"]){
        result.status = YGPayStatusFailed;
    }
    return result;
}

//+ (instancetype)applepayResult:(UPPayResult *)payResult
//{
//    YGPaymentResult *result = [YGPaymentResult new];
//    result.originData = payResult;
//    result.sessionId = SESSION.token;
//    
//    switch (payResult.paymentResultStatus) {
//        case UPPaymentResultStatusSuccess: result.status = YGPayStatusSuccess;break;
//        case UPPaymentResultStatusFailure: result.status = YGPayStatusFailed;break;
//        case UPPaymentResultStatusCancel:  result.status = YGPayStatusCanceled;break;
//        case UPPaymentResultStatusUnknownCancel:result.status = YGPayStatusCanceled;break;
//    }
//    return result;
//}

#if PingppSDK_Enabled
+ (instancetype)pingppResult:(NSString *)result error:(PingppError *)error
{
    YGPaymentResult *instance = [YGPaymentResult new];
    
    if ([result isEqualToString:@"success"]) {
        instance.status = YGPayStatusSuccess;
    }else{
        
        if (error.code == PingppErrCancelled ||
            error.code == PingppErrUnknownCancel) {
            instance.status = YGPayStatusCanceled;
        }else if (error.code == PingppErrChannelReturnFail ||
                  error.code == PingppErrUnknownError ||
                  error.code == PingppErrConnectionError ||
                  error.code == PingppErrRequestTimeOut){
            instance.status = YGPayStatusFailed;
        }
    }
    return instance;
}
#endif

@end

#if AlipaySDK_Enabled
NSString * AliPayResultMessage(AlipayStatus status){
    switch (status) {
        case AlipayStatusSuccess:   return @"订单支付成功";   break;
        case AlipayStatusPaying:    return @"正在处理中";    break;
        case AlipayStatusFailed:    return @"订单支付失败";   break;
        case AlipayStatusCanceled:  return @"用户中途取消";   break;
        case AlipayStatusNetworkErr: return @"网络连接出错";  break;
    }
    return nil;
}
#endif
