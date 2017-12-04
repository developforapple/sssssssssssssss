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


YG_EXTERN BOOL isProVersion(void){
    return [AppBundleID isEqualToString:@"com.wwwbbat.sp.pro"];
}
