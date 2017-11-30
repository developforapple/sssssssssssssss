//
//  SPStarManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPStarManager : NSObject

+ (instancetype)manager;

- (NSArray<NSString *> *)getRecord:(NSInteger)orderId
                          pageSize:(int)pageSize;

- (void)add:(NSString *)token;
- (void)remove:(NSString *)token;

- (BOOL)isStarred:(NSString *)token;

@end
