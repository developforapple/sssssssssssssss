//
//  CDTRequestManager.m
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/29.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import "API.h"

@implementation CDTRequestManager

+ (instancetype)manager
{
    static CDTRequestManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [CDTRequestManager managerWithHost:kAPIURL];
    });
    return api;
}

#pragma mark - Push
- (DDTASK)submitPushToken:(NSString *)token
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"lcDeviceToken"] = token;
    param[@"pushDevice"] = @"0";
    return DDPOST(@"cdt/pushTokenAdd", param, suc, fail);
}

- (DDTASK)fetchPushSetting:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    return DDGET(@"cdt/pushTypeGet", nil, suc, fail);
}

- (DDTASK)submitPushSetting:(BOOL)on
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"isPush"] = @(on);
    return DDPOST(@"cdt/pushOpen", param, suc, fail);
}

#pragma mark - Neaby
- (DDTASK)nearbyList:(double)lat
           longitude:(double)lon
                type:(CDTNearbyItemType)itemType
                sort:(long long)sortTime
             success:(DDRespSucBlock)suc
             failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"lat"] = @(lat);
    param[@"lng"] = @(lon);
    param[@"type"] = @(itemType);
    param[@"sortTime"] = @(sortTime);
    param[@"limit"] = @20;
    return DDPOST(@"cdt/nearbyGetList_v2", param, suc, fail);
}

- (DDTASK)searchNearbyList:(NSString *)keywords
                  latitide:(NSNumber *)lat
                 longitude:(NSNumber *)lon
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"keyword"] = keywords;
    param[@"lat"] = lat;
    param[@"lng"] = lon;
    return DDPOST(@"cdt/searchNearbyList_v2", param, suc, fail);
}

- (DDTASK)fetchShopDetail:(NSInteger)sid
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"sid"] = @(sid);
    return DDPOST(@"cdt/shopDetailsGet", param, suc, fail);
}

- (DDTASK)fetchTerminalPictures:(NSString *)terminal
                           type:(int)terminalType
                        success:(DDRespSucBlock)suc
                        failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminal;
    param[@"terminalType"] = @(terminalType);
    return DDPOST(@"cdt/shopPomotionPhotoGet", param, suc, fail);
}

#pragma mark - logic

- (DDTASK)checkTerminalInfo:(NSString *)terminalId
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminalId;
    return DDPOST(@"cdt/deviceCheckLineAndCDB2", param, suc, fail);
}

- (DDTASK)createPayment:(NSString *)channel
                 amount:(NSInteger)amount
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"channel"] = channel;
    param[@"amount"] = @(amount);
    return DDPOST(@"cdt/chargeCreate", param, suc, fail);
}

- (DDTASK)createRentTask:(NSString *)terminalId
                 cdbType:(int)cdbType
            batteryLevel:(NSString *)encryptedLevel
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminalId;
    param[@"cdbType"] = @(cdbType);
    param[@"batteryLevel"] = encryptedLevel;
    return DDPOST(@"cdt/taskAdd", param, suc, fail);
}

- (DDTASK)createBuyTask:(NSString *)terminalId
               lineType:(NSInteger)type
                 coupon:(nullable NSNumber *)couponId
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminalId;
    param[@"lineType"] = @(type);
    param[@"ticketId"] = couponId;
    return DDPOST(@"cdt/taskAddBuyLine", param, suc, fail);
}

- (DDTASK)checkTask:(NSInteger )taskId
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"taskId"] = @(taskId);
    return DDPOST(@"cdt/webTaskGet", param, suc, fail);
}

- (DDTASK)fetchCurrentRecord:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail
{
    return DDPOST(@"cdt/checkHistoryInfoGet", nil, suc, fail);
}

- (DDTASK)fetchBorrowedList:(NSInteger)type
                    success:(DDRespSucBlock)suc
                    failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(type);
    return DDPOST(@"cdt/checkHistoryGet", param, suc, fail);
}

- (DDTASK)returnCDB:(NSString *)cdbId
           terminal:(NSString *)terminal
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cdbID"] = cdbId;
    param[@"terminal"] = terminal;
    param[@"platform"] = @"iOS";
    return DDPOST(@"cdt/taskAddRecycle", param, suc, fail);
}

- (DDTASK)checkReturnTask:(NSString *)taskId
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"taskId"] = taskId;
    param[@"platform"] = @"iOS";
    return DDPOST(@"cdt/taskGetRecycle", param, suc, fail);
}

#pragma mark - User
- (DDTASK)fetchUserInfo:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail
{
    return DDPOST(@"cdt/UserGet", nil, suc, fail);
}

- (DDTASK)fetchCouponList:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    return DDPOST(@"cdt/webTicketGet_v2", nil, suc, fail);
}

- (DDTASK)addCoupon:(NSInteger)event
               code:(NSString *)code
            success:(DDRespSucBlock)suc
            failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"eventId"] = @(event);
    param[@"couponQRCode"] = code;
    return DDPOST(@"cdt/couponUse", param, suc, fail);
}

- (DDTASK)fetchCDBRecordList:(NSNumber *)sortId
                     success:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"count"] = @(kDefaultPageSize);
    param[@"sortTime"] = sortId;
    param[@"version"] = @2;
    return DDPOST(@"cdt/webCheckHistoryGet", param, suc, fail);
}

- (DDTASK)fetchBuyLineRecordList:(NSNumber *)sortId
                         success:(DDRespSucBlock)suc
                         failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"count"] = @(kDefaultPageSize);
    param[@"sortTime"] = sortId;
    return DDPOST(@"cdt/webBuyLineHistoryGet", param, suc, fail);
}

- (DDTASK)fetchTradeList:(NSNumber *)sortId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"count"] = @(kDefaultPageSize);
    param[@"sortTime"] = sortId;
    return DDPOST(@"cdt/webTransactionRecordListGet", param, suc, fail);
}

- (DDTASK)fetchTradeDetail:(NSString *)tradeId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"recordId"] = tradeId;
    return DDPOST(@"cdt/webTransactionRecordGet", param, suc, fail);
}

- (DDTASK)fetchAuthCode:(NSString *)phone
                   type:(NSInteger)type
                success:(DDRespSucBlock)suc
                failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = phone;
    param[@"type"] = @(type);
    return DDPOST(@"cdt/authCodeGet", param, suc, fail);
}

- (DDTASK)bindPhoneNumber:(NSString *)phone
                     code:(NSString *)code
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = phone;
    param[@"authCode"] = code;
    return DDPOST(@"cdt/authCodeBoundPhoneForWeiXin", param, suc, fail);
}

- (DDTASK)submitWithdrawRequest:(float)amount
                        success:(DDRespSucBlock)suc
                        failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cashPickup"] = @(amount);
    return DDPOST(@"cdt/cashPickup", param, suc, fail);
}

- (DDTASK)fetchTerminalAD:(NSString *)terminal
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminal;
    return DDPOST(@"cdt/redPacketAdListGet", param, suc, fail);
}

#pragma mark - Login
- (DDTASK)wechatAuthLogin:(NSString *)wechatCode
                     uuid:(NSString *)uuid
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = wechatCode;
    param[@"uuId"] = uuid;
    return DDPOST(@"cdt/wxAPPAuthCode", param, suc, fail);
}

- (DDTASK)loginUsingWechat:(NSDictionary *)info
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    return DDPOST(@"cdt/userLoginBy3Party", info, suc, fail);
}

- (DDTASK)login:(NSString *)phone
           code:(NSString *)code
           uuid:(NSString *)uuid
        success:(DDRespSucBlock)suc
        failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = phone;
    param[@"authCode"] = code;
    param[@"uuId"] = uuid;
    return DDPOST(@"cdt/authCodeLogin", param, suc, fail);
}

#pragma mark - Zhima
- (DDTASK)createZhimaURL:(NSString *)terminal
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminal;
    return DDPOST(@"cdt/alipayZhiMaURLCreate", param, suc, fail);
}

@end
