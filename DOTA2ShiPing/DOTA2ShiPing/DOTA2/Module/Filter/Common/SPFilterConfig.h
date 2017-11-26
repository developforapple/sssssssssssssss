//
//  SPFilterConfig.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFilterConfig : NSObject

// 是否允许同时选择多个选项，默认为YES
@property (assign, nonatomic) BOOL allowsMultipleSelection;
// 是否允许在同一个group中同时选择多个选项。默认为YES。
@property (assign, nonatomic) BOOL allowsMultipleSelectionInSection;

+ (instancetype)defaultConfig;

@end
