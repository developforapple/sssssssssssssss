//
//  SPItemSlot.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/15.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@interface SPItemSlot : SPObject <NSCopying,NSCoding>

// 2
@property (assign, nonatomic) int SlotIndex;
// armor
@property (copy, nonatomic) NSString *SlotName;
// #LoadoutSlot_Armor
@property (copy, nonatomic) NSString *SlotText;

// 后期生成的属性
@property (copy, nonatomic) NSString *name_loc;

@end
