//
//  Config_Archive.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_Archive.h"

#if TARGET_PRO
    NSString *const kAppAppleID = @"1320759350";
#elif TARGET_AD
    NSString *const kAppAppleID = @"1133984826";
#elif TARGET_OLD
    NSString *const kAppAppleID = @"767324842";
#else
    NSString *const kAppAppleID = @"1133984826";
#endif

#if InHouseVersion
NSString *const kAppChannel = @"InHouse";
NSString *const kAppChannelID = @"0";
#else
NSString *const kAppChannel = @"AppStore";
NSString *const kAppChannelID = @"1";
#endif
