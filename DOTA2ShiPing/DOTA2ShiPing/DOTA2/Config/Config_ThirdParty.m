//
//  Config_ThirdParty.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_ThirdParty.h"

#if InHouseVersion
NSString *const kUMengAppKey = @"";
#else
NSString *const kUMengAppKey = @"";
#endif

NSString *const kQQAppID = @"";
NSString *const kQQAppKey = @"";
NSString *const kQQScheme = @"";

// 1: Build Setting/User-Defined 中定义环境变量 BUGLY_APP_ID
// 2: Build Phases/Compile Sources/Config_ThirdParty.m 设置 Compiler Flags:
//    -D'MACRO_BUGLY_APP_ID=@"$(BUGLY_APP_ID)"
NSString *const kBuglyAppID = MACRO_BUGLY_APP_ID;

NSString *const kWeiboAppKey = @"";
NSString *const kWeiboScheme = @"";

NSString *const kWechatAppID  = @"";
NSString *const kWechatAppSecret = @"";
NSString *const kWechatScheme = @"";

NSString *const kBaiduAppKey = @"";

#if InHouseVersion
NSString *const kPgyAppID = @"075d268f75cfde6e8b410eddb31feab2";
#else
NSString *const kPgyAppID = @"";
#endif

NSString *const kAlipayScheme = @"";

NSString *const kZhimaAppID = @"";

NSString *const kUnionPayScheme = @"";

#if DEBUG_MODE
NSString *const kPayPalClientID = @"";
#else
NSString *const kPayPalClientID = @"";
#endif

#if TARGET_PRO
// pro 359826224@qq.com 刀塔饰品Pro
NSString *const kLeanCloudAppID = @"nyAIoo7OddnRAE0Ch7WOTjRx-gzGzoHsz";
NSString *const kLeanCloudAppKey = @"IVLqzHqTqdjbXch8YekoUEdf";
#elif TARGET_AD
// ad 359826224@qq.com 刀塔饰品Ad
NSString *const kLeanCloudAppID = @"K1mtJOrizsvrywTyYq85j3xL-gzGzoHsz";
NSString *const kLeanCloudAppKey = @"6VNgktNuzuT7exKg1fTF8x4q";
#else
// dev developforapple@163.com 饰品总汇
NSString *const kLeanCloudAppID = @"uy7j0G50gYzI8jOopjxUNPpT-gzGzoHsz";
NSString *const kLeanCloudAppKey = @"RkF7f6l3KjnnOKA7jTD1YFn7";
#endif

NSString *const kPingppAppID = @"";

#if InHouseVersion
NSString *const kGaodeMapKey = @"";
#else
NSString *const kGaodeMapKey = @"";
#endif

#if TARGET_PRO
NSString *const kAdMobAppID = @"";
NSString *const kAdMobBannerUnitID = @"";
NSString *const kAdMobRewardVideoUnitID = @"";
NSString *const kAdMobLaunchADUnitID = @"";
#elif 0
// test key
NSString *const kAdMobAppID = @"ca-app-pub-3317628345096940~4597769315";
NSString *const kAdMobBannerUnitID = @"ca-app-pub-3940256099942544/6300978111";
NSString *const kAdMobRewardVideoUnitID = @"ca-app-pub-3940256099942544/4411468910";
NSString *const kAdMobLaunchADUnitID = @"ca-app-pub-3940256099942544/4411468910";
#else
// ad
NSString *const kAdMobAppID = @"ca-app-pub-3317628345096940~4597769315";
NSString *const kAdMobBannerUnitID = @"ca-app-pub-3317628345096940/6074502516";
NSString *const kAdMobRewardVideoUnitID = @"ca-app-pub-3317628345096940/6527269232";
NSString *const kAdMobLaunchADUnitID = @"ca-app-pub-3317628345096940/4910935239";
#endif

#if TARGET_PRO
NSString *const kTencentGDTAppKey = @"1106570472";
NSString *const kTencentGDTLaunchPOSID = @"";
NSString *const kTencentGDTBannerPOSID = @"";
#else
NSString *const kTencentGDTAppKey = @"1106592268";
NSString *const kTencentGDTLaunchPOSID = @"7000325834304018";
NSString *const kTencentGDTBannerPOSID = @"5080728864708037";
#endif

