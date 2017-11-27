//
//  SPDotabuffAPI.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

// DotaBuff
@interface SPDotabuffAPI : SPObject

+ (void)searchUser:(NSString *)keywords
        completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion;

@end
