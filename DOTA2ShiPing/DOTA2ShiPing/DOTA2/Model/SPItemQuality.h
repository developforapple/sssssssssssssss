//
//  SPItemQuality.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItemQuality : NSObject <NSCopying,NSCoding>

@property (strong, nonatomic) NSString *displayname;
@property (strong, nonatomic) NSString *name_cn;
@property (strong, nonatomic) NSNumber *sortpriority;
@property (strong, nonatomic) NSString *hexcolor;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSString *name;

@end
