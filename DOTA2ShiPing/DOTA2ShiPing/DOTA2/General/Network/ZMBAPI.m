//
//  ZMBRequestManager.m
//  CDT
//
//  Created by wwwbbat on 2017/6/29.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "ZMBAPI.h"

@implementation ZMBRequestManager

+ (instancetype)zmbManager
{
    static ZMBRequestManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [ZMBRequestManager managerWithHost:kZMBAPIURL];
    });
    return api;
}

- (DDTASK)fetchZMBRecordList:(NSNumber *)sortId
                     success:(DDRespSucBlock)suc
                     failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"count"] = @(kDefaultPageSize);
    param[@"sortTime"] = sortId;
    return DDPOST(@"ldb/ldbChargeList", param, suc, fail);
}

- (DDTASK)endZMBCharge:(NSString *)chargeId
               success:(DDRespSucBlock)suc
               failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = chargeId;
    return DDPOST(@"ldb/ldbStopCharge", param, suc, fail);
}

- (DDTASK)beginZMBCharge:(NSString *)terminal
            encrytedData:(NSString *)data
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminal;
    param[@"encryptedData"] = data;
    return DDPOST(@"ldb/ldbCharge", param, suc, fail);
}

- (DDTASK)payForZMBOrder:(NSString *)chargeId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = chargeId;
    return DDPOST(@"ldb/ldbChargePay", param, suc, fail);
}

- (DDTASK)fetchZMBTroubleList:(DDRespSucBlock)suc
                      failure:(DDRespFailBlock)fail
{
    return DDGET(@"ldb/ldbFailureGet", nil, suc, fail);
}

- (DDTASK)submitZMBTrouble:(NSString *)troubleid
                  terminal:(NSString *)terminalId
                    remark:(NSString *)remark
                  recordId:(NSString *)recordId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"failureId"] = troubleid;
    param[@"terminal"] = terminalId;
    param[@"remark"] = remark;
    param[@"chargeHistoryId"] = recordId;
    return DDPOST(@"ldb/ldbFailureReport", param, suc, fail);
}

- (DDTASK)fetchZMBTerminal:(NSString *)terminalId
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"terminal"] = terminalId;
    return DDPOST(@"ldb/ldbDeviceInfoGet", param, suc, fail);
}

- (DDTASK)fetchZMBRecord:(NSString *)recordId
                 success:(DDRespSucBlock)suc
                 failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"chargeHistoryId"] = recordId;
    return DDPOST(@"ldb/ldbChargeInfoGet", param, suc, fail);
}

- (DDTASK)createZMBPayment:(NSString *)channel
                     bizId:(NSString *)bizId
                    amount:(NSInteger)amount
                   success:(DDRespSucBlock)suc
                   failure:(DDRespFailBlock)fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"channel"] = channel;
    param[@"bizId"] = bizId;
    param[@"amount"] = @(amount);
    return DDPOST(@"ldb/ldbChargePayCreate", param, suc, fail);
}

@end
