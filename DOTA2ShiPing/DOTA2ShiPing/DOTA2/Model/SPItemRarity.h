//
//  SPItemRarity.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

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

@interface SPItemRarity : SPObject <NSCopying,NSCoding>

// common
@property (copy, nonatomic) NSString *name;
// Rarity_Common
@property (copy, nonatomic) NSString *loc_key;
// 1
@property (copy, nonatomic) NSString *value;
// desc_common
@property (copy, nonatomic) NSString *color;


@property (copy, nonatomic) NSString *name_loc;

@end
