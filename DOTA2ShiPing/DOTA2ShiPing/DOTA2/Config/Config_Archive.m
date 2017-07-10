//
//  Config_Archive.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_Archive.h"

NSString *const kAppAppleID = @"767324842";

#if InHouseVersion
NSString *const kAppChannel = @"InHouse";
NSString *const kAppChannelID = @"0";
#else
NSString *const kAppChannel = @"AppStore";
NSString *const kAppChannelID = @"1";
#endif

// 1: Build Setting/User-Defined 中定义环境变量 CDT_APP_BUNDLE_ID
// 2: Build Phases/Compile Sources/Config_Archive.m 设置 Compiler Flags:
//    -D'MACRO_APP_BUNDLE_ID=@"$(CDT_APP_BUNDLE_ID)"
NSString *const kAppBundleID = MACRO_APP_BUNDLE_ID;
