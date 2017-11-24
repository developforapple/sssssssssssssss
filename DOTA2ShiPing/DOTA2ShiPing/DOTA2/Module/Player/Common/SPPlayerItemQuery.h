//
//  SPPlayerItemQuery.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlayerItemSharedData.h"
#import "SPItem.h"

@interface SPPlayerItemQuery : NSObject

+ (instancetype)queryWithPlayerItems:(SPPlayerItemSharedData *)data;

@property (strong, nonatomic) SPPlayerItemSharedData *playerItemData;

// 从0开始，当前第几页
@property (assign, nonatomic) NSInteger pageNo;

// 过滤选项
@property (strong, nonatomic) id options;

- (NSArray<SPItem *> *)loadPage:(NSInteger)page;

// 更改过滤选项会刷新所有数据
- (void)filter:(id)options;

@end
