//
//  CDTRequestManager.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/29.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import "DDRequestManager.h"

#define API     [CDTRequestManager manager]

@interface CDTRequestManager : DDRequestManager

+ (instancetype)manager;

#pragma mark - Push

/**
 上传推送token
 
 @param token token字符串
 @param suc suc description
 @param fail fail description
 @return return value description
 */
- (DDTASK)submitPushToken:(NSString *)token
                  success:(DDRespSucBlock)suc
                  failure:(DDRespFailBlock)fail;

@end
