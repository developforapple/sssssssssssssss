//
//  Config_Network.h
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Config_Network_h
#define Config_Network_h

#include "Defines.h"
#include "ConfigDefines.h"

@class NSString;

// YES: 生产环境 NO：测试环境
YG_EXTERN const BOOL kProductionEnvironment;

YG_EXTERN NSString *const kAppHost;     //app host
YG_EXTERN NSString *const kZMBHost;     //桌面宝 host
YG_EXTERN NSString *const kAPIURL;      //app api base url
YG_EXTERN NSString *const kZMBAPIURL;   //桌面宝 api base url
YG_EXTERN NSString *const kAppWechatHost;

YG_EXTERN NSString *const kAppUsageAgreement;       // 服务协议
YG_EXTERN NSString *const kAppRechargeAgreement;    // 充值协议
YG_EXTERN NSString *const kAppDespoitGuide;         // 押金说明
YG_EXTERN NSString *const kAppHelpCenter;           // 帮助中心
YG_EXTERN NSString *const kAppWithdrawHelp;         // 提现帮助
YG_EXTERN NSString *const kAppBusiness;             // 商务
YG_EXTERN NSString *const kAppZMBHelp;              // 桌面宝帮助


// Base URL

#endif /* Config_Network_h */
