//
//  SPItemQuality.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItemQuality : NSObject <NSCopying,NSCoding>

// genuine
@property (copy, nonatomic) NSString *name;
// 1
@property (copy, nonatomic) NSString *value;
// #4D7455
@property (copy, nonatomic) NSString *hexColor;
// 20
@property (copy, nonatomic) NSString *sortPriority;
// #genuine
@property (copy, nonatomic) NSString *displayName;

// 后期生成的属性
@property (copy, nonatomic) NSString *name_loc;

@end
