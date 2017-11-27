//
//  SPGamepediaAPI.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPGamepediaData.h"

@class SPItem;

typedef void (^SPGamepediaAPICompletion)(BOOL suc, SPGamepediaData *data);

typedef NS_ENUM(NSUInteger, SPGamepediaAPIErrorCode) {
    SPGamepediaAPIErrorCodeUnexpectedResponse = 10086,
};

@interface SPGamepediaAPI : SPObject

+ (instancetype)shared;

- (void)fetchItemInfo:(SPItem *)item
           completion:(SPGamepediaAPICompletion)completion;

@end
