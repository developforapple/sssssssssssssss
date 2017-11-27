//
//  SPWebHelper.h
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class UIViewController;

@interface SPWebHelper : SPObject

+ (void)openURL:(NSURL *)URL from:(UIViewController *)vc;

@end
