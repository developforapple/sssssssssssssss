//
//  ThirdParty.h
//  CDT
//
//  Created by wwwbbat on 2017/6/20.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#ifndef ThirdParty_h
#define ThirdParty_h

#define YG_SDK_ENABLED(header) yg_has_include(header)

// 友盟
#define UMengSDK_Enabled    YG_SDK_ENABLED     (UMMobClick/MobClick.h)

// QQ
#define QQSDK_Enabled       YG_SDK_ENABLED     (TencentOpenAPI/QQApiInterface.h)

// Bugly
#define BuglySDK_Enabled    YG_SDK_ENABLED     (Bugly/Bugly.h)

// 微博
#define WeiboSDK_Enabled    YG_SDK_ENABLED     (WeiboSDK.h)

// 微信
#define WechatSDK_Enabled   YG_SDK_ENABLED     (WXApi.h)

// 百度
#define BaiduSDK_Enabled    0

// 百度地图
#define BaiduMapSDK_Enabled 0

// 蒲公英
#define PgySDK_Enabled      YG_SDK_ENABLED     (PgySDK/PgyManager.h)

// 支付宝
#define AlipaySDK_Enabled   YG_SDK_ENABLED     (AlipaySDK/AlipaySDK.h)

// 芝麻信用
#define ZhimaSDK_Enabled    YG_SDK_ENABLED     (ZMCert/ZMCert.h)

// 银联
#define UPPaySDK_Enabled    YG_SDK_ENABLED     (UPPaymentControl.h)

// 银联的ApplePay
#define ApplePaySDK_Enabled YG_SDK_ENABLED     (UPAPayPlugin.h)

// Paypal
#define PaypalSDK_Enabled   0

// LeanCloud
#define LeanCloudSDK_Enabled YG_SDK_ENABLED    (AVOSCloud.h)

// Ping++
#define PingppSDK_Enabled   YG_SDK_ENABLED     (Pingpp.h)

// 高德
#define GaodeSDK_Enabled    YG_SDK_ENABLED     (AMapFoundationKit/AMapFoundationKit.h)

#endif /* ThirdParty_h */
