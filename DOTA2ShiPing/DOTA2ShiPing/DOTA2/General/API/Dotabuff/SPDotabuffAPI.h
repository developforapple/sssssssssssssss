//
//  SPDotabuffAPI.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

// DotaBuff
@interface SPDotabuffAPI : NSObject

+ (void)searchUser:(NSString *)keywords
        completion:(void (^)(BOOL suc, NSArray *list, NSString *msg)) completion;

@end
