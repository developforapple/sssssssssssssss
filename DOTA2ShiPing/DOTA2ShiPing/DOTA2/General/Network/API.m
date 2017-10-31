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

@end
