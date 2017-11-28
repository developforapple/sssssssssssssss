//
//  SPPlayerItemQuery.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPPlayerItemSharedData.h"
#import "SPItem.h"
#import "SPPlayerItemFilterUnit.h"

@interface SPPlayerItemQuery : SPObject

+ (instancetype)queryWithPlayerItems:(SPPlayerItemSharedData *)data;

@property (strong, nonatomic) SPPlayerItemSharedData *playerItemData;
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *filteredPlayerItems;

// 从0开始，当前第几页
@property (assign, nonatomic) NSInteger pageNo;

// 过滤选项
@property (strong, nonatomic) NSArray<SPPlayerItemFilterUnit *> *units;

- (NSArray<SPItem *> *)loadPage:(NSInteger)page;

// 更改过滤选项会刷新所有数据
- (void)filter:(NSArray<SPPlayerItemFilterUnit *> *)units;

@end
