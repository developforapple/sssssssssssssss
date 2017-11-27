//
//  YGPaymentResult.h
//  Golf
//
//  Created by bo wang on 2016/10/27.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, YGPayStatus) {
    YGPayStatusSuccess = 0,
    YGPayStatusFailed = 1,
    YGPayStatusCanceled = 2,
};

@class UPPayResult;
@class BaseResp;
@class PingppError;

@interface YGPaymentResult : SPObject

@property (strong, nonatomic) id originData;

@property (copy, nonatomic) NSString *sessionId;
@property (assign, nonatomic) NSInteger tranId;
@property (assign, nonatomic) YGPayStatus status; //0成功 1失败 2取消


+ (instancetype)wechatResult:(BaseResp *)resp;
+ (instancetype)alipayResult:(NSDictionary *)result;
+ (instancetype)unionpayResult:(NSString *)result;
//+ (instancetype)applepayResult:(UPPayResult *)result;

#if PingppSDK_Enabled
+ (instancetype)pingppResult:(NSString *)result error:(PingppError *)error;
#endif

@end

typedef NS_ENUM(NSUInteger, AlipayStatus) {
    AlipayStatusSuccess = 9000,     //成功
    AlipayStatusPaying = 8000,      //正在支付
    AlipayStatusFailed = 4000,      //失败
    AlipayStatusCanceled = 6001,    //用户取消
    AlipayStatusNetworkErr = 6002,  //网络错误
};

#if AlipaySDK_Enabled
    FOUNDATION_EXTERN NSString * AliPayResultMessage(AlipayStatus status);
#endif
