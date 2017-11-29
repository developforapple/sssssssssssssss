//
//  SPHistoryManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPHistoryManager : NSObject

+ (instancetype)manager;


/**
 获取历史列表

 @param orderId 最后一个orderid。或者0。为0时读取最新的。
 @param pageSize 每次读取的数据大小。
 @return 同步返回。
 */
- (NSArray<NSString *> *)getHistory:(NSInteger)orderId
                           pageSize:(int)pageSize;


/**
 添加记录。当token已存在记录中时，将会将它设为最新。

 @param token token
 */
- (void)add:(NSString *)token;

@end
