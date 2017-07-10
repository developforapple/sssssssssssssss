//
//  UIDevice+Ext.m
//
//  Created by WangBo on 2017/4/13.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIDevice+Ext.h"
#include <sys/utsname.h>

@implementation UIDevice (Ext)

+ (NSString *)hardwareName
{
    static NSString *hardware;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname sysInfo;
        uname(&sysInfo);
        hardware = [NSString stringWithUTF8String:sysInfo.machine];
    });
    return hardware;
}

@end
