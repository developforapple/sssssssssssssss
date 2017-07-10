//
//  Config_Network.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_Network.h"

const BOOL kProductionEnvironment = ProductionEnvironment;

#if ProductionEnvironment
    //生产环境
    #define __HOST__                    @"mobile-api.imlaidian.com"
    #define __ZMB_HOST__                @"zmb-api.imlaidian.com/"
    #define __API_URL__                 @"https://mobile-api.imlaidian.com"
    #define __ZMB_API_URL__             @"https://zmb-api.imlaidian.com"
    #define __APP_WECHAT_HOST__         @"wx.imlaidian.com"

    #define __APP_USAGE_AGREEMENT__     @"https://wx.imlaidian.com/share/usageAgreement.html"
    #define __APP_RECHARGE_AGGREEMENT__ @"https://wx.imlaidian.com/share/rechargeAgreement.html"
    #define __APP_DESPOIT_GUIDE__       @""
    #define __APP_HELP_CENTER__         @"https://wx.imlaidian.com/share/helpCenter.html"
    #define __APP_WITHDRAW_HELP__       @"https://mp.weixin.qq.com/s?idx=1&sn=4de3a87205f52cce621d0009bf591e07&__biz=MzA4MTI0OTA5NA==&mid=401284710"
    #define __APP_BUSINESS__            @"https://wx.imlaidian.com/cdt/cooperationApply?code=041msGZT0gBbqU1YXP0U04jxZT0msGZV&state=1"
    #define __APP_ZMB_HELP__            @"https://wx.imlaidian.com/zhuomianbao/help.html"
#else
    //测试环境
    #define __HOST__                    @"mobile-api-test.imlaidian.com"
    #define __ZMB_HOST__                @"zmb-api-test.imlaidian.com"
    #define __API_URL__                 @"https://mobile-api-test.imlaidian.com"
    #define __ZMB_API_URL__             @"https://zmb-api-test.imlaidian.com"
    #define __APP_WECHAT_HOST__         @"wx.imlaidian.com"

    #define __APP_USAGE_AGREEMENT__     @"https://wx.imlaidian.com/share/usageAgreement.html"
    #define __APP_RECHARGE_AGGREEMENT__ @"https://wx.imlaidian.com/share/rechargeAgreement.html"
    #define __APP_DESPOIT_GUIDE__       @""
    #define __APP_HELP_CENTER__         @"https://wx.imlaidian.com/share/helpCenter.html"
    #define __APP_WITHDRAW_HELP__       @"https://mp.weixin.qq.com/s?idx=1&sn=4de3a87205f52cce621d0009bf591e07&__biz=MzA4MTI0OTA5NA==&mid=401284710"
    #define __APP_BUSINESS__            @"https://wx.imlaidian.com/cdt/cooperationApply?code=041msGZT0gBbqU1YXP0U04jxZT0msGZV&state=1"
    #define __APP_ZMB_HELP__            @"https://wx.imlaidian.com/zhuomianbao/help.html"
#endif

NSString *const kAppHost        =   __HOST__;
NSString *const kZMBHost        =   __ZMB_HOST__;
NSString *const kAPIURL         =   __API_URL__;
NSString *const kZMBAPIURL      =   __ZMB_API_URL__;
NSString *const kAppWechatHost  =   __APP_WECHAT_HOST__;

NSString *const kAppUsageAgreement      = __APP_USAGE_AGREEMENT__;
NSString *const kAppRechargeAgreement   = __APP_RECHARGE_AGGREEMENT__;
NSString *const kAppDespoitGuide        = __APP_DESPOIT_GUIDE__;
NSString *const kAppHelpCenter          = __APP_HELP_CENTER__;
NSString *const kAppWithdrawHelp        = __APP_WITHDRAW_HELP__;
NSString *const kAppBusiness            = __APP_BUSINESS__;
NSString *const kAppZMBHelp             = __APP_ZMB_HELP__;


#undef __HOST__
#undef __SHARE_URL__
#undef __API_URL__

