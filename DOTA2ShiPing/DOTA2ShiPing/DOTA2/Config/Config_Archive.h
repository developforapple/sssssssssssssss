//
//  Config_Archive.h
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Config_Archive_h
#define Config_Archive_h

#include "Defines.h"
#include "ConfigDefines.h"

YG_EXTERN NSString *const kAppAppleID;
// 渠道
YG_EXTERN NSString *const kAppChannel;
// 渠道id。AppStore：1 InHouse：0
YG_EXTERN NSString *const kAppChannelID;

YG_EXTERN BOOL isProVersion(void);


#endif /* Config_Archive_h */
