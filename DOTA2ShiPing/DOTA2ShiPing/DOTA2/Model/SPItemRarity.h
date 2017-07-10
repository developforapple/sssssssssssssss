//
//  SPItemRarity.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 common,    普通
 rare,      稀有
 mythical,  神话
 ancient,   远古
 arcana,    至宝
 seasonal,  勇士令状
 immortal,  不朽
 legendary, 传说
 uncommon   罕见
 
 */

@interface SPItemRarity : NSObject <NSCopying,NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *name_cn;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSNumber *value;  //1

@end
