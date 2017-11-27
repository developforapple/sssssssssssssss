//
//  SPFilterConfig.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@interface SPFilterConfig : SPObject

// 是否允许同时选择多个选项，默认为YES
@property (assign, nonatomic) BOOL allowsMultipleSelection;
// 是否允许在同一个group中同时选择多个选项。默认为YES。
@property (assign, nonatomic) BOOL allowsMultipleSelectionInSection;

+ (instancetype)defaultConfig;

@end
