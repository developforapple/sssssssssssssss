//
//  SPGamepediaAPI.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGamepediaData.h"

@class SPItem;

typedef void (^SPGamepediaAPICompletion)(BOOL suc, SPGamepediaData *data);

typedef NS_ENUM(NSUInteger, SPGamepediaAPIErrorCode) {
    SPGamepediaAPIErrorCodeUnexpectedResponse = 10086,
};

@interface SPGamepediaAPI : NSObject

+ (instancetype)shared;

- (void)fetchItemInfo:(SPItem *)item
           completion:(SPGamepediaAPICompletion)completion;

@end
