//
//  Config_ThirdParty.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_ThirdParty.h"

#if InHouseVersion
NSString *const kUMengAppKey = @"54dc5626fd98c53ac3001452";
#else
NSString *const kUMengAppKey = @"54dc5626fd98c53ac3001452";
#endif


NSString *const kQQAppID = @"1104293404";
NSString *const kQQAppKey = @"Bekay8Cbvjx9eFOR";
NSString *const kQQScheme = @"QQ41D22E1C";

// 1: Build Setting/User-Defined 中定义环境变量 BUGLY_APP_ID
// 2: Build Phases/Compile Sources/Config_ThirdParty.m 设置 Compiler Flags:
//    -D'MACRO_BUGLY_APP_ID=@"$(BUGLY_APP_ID)"
NSString *const kBuglyAppID = MACRO_BUGLY_APP_ID;


NSString *const kWeiboAppKey = @"";
NSString *const kWeiboScheme = @"";

NSString *const kWechatAppID  = @"wx1f83882082346a51";
NSString *const kWechatAppSecret = @"450bf4b84063d53e0d56fc12e3ec6ea1";
NSString *const kWechatScheme = @"wx1f83882082346a51";

#if InHouseVersion
NSString *const kBaiduAppKey = @"NmswvpnTFoL022wAf8yGhGwj";
#else
NSString *const kBaiduAppKey = @"XP5AeSOEo7KKjpjBIXdvR6Lx";
#endif

NSString *const kPgyAppID = @"075d268f75cfde6e8b410eddb31feab2";

NSString *const kAlipayScheme = @"cdtalipay";

NSString *const kZhimaAppID = @"2015122301028465";

NSString *const kUnionPayScheme = @"cdtuppay";

#if DEBUG_MODE
NSString *const kPayPalClientID = @"AUcpLj-DFofxPW8u6g17_Xv5FKyx3ii731oBUjHDxIimLZOLlcQBaXC-tct0JAqtPkGOO2gA5aByndJL";
#else
NSString *const kPayPalClientID = @"AfmR3k1azm3liMETPeKE4gOXwXTXdK9eZgBjsj1kL6X4HGzw-8Bdc9yW87zZYQI5G7TI3-mMwyR4SCih";
#endif

NSString *const kLeanCloudAppID = @"uy7j0G50gYzI8jOopjxUNPpT-gzGzoHsz";
NSString *const kLeanCloudAppKey = @"RkF7f6l3KjnnOKA7jTD1YFn7";

NSString *const kPingppAppID = @"app_vL4CG01iD8mTW9SW";

#if InHouseVersion
NSString *const kGaodeMapKey = @"ad43500ec50ef5c0d55882806361c273";
#else
NSString *const kGaodeMapKey = @"4119abb7eb3fbe01e0c28ab9b5b9c629";
#endif

NSString *const kAdMobAppID = @"ca-app-pub-3317628345096940~4597769315";
#if 0//DEBUG_MODE
NSString *const kAdMobBannerUnitID = @"ca-app-pub-3940256099942544/6300978111";
NSString *const kAdMobRewardVideoUnitID = @"ca-app-pub-3940256099942544/4411468910";
NSString *const kAdMobLaunchADUnitID = @"ca-app-pub-3940256099942544/4411468910";
#else
NSString *const kAdMobBannerUnitID = @"ca-app-pub-3317628345096940/6074502516";
NSString *const kAdMobRewardVideoUnitID = @"ca-app-pub-3317628345096940/6527269232";
NSString *const kAdMobLaunchADUnitID = @"ca-app-pub-3317628345096940/4910935239";
#endif


NSString *const kTencentGDTAppKey = @"1106570472";
NSString *const kTencentGDTLaunchPOSID = @"8020528862264174";
