//
//  SPGamepediaAPI.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SPGamepediaAPICompletion)(BOOL suc, NSError *error, id result);

@interface SPGamepediaAPI : NSObject

+ (instancetype)shared;

- (void)fetchItem:(NSString *)itemName
       completion:(SPGamepediaAPICompletion)completion;

@end
