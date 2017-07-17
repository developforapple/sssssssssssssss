//
//  SPItemSlot.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/15.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItemSlot : NSObject <NSCopying,NSCoding>

// 2
@property (assign, nonatomic) int SlotIndex;
// armor
@property (copy, nonatomic) NSString *SlotName;
// #LoadoutSlot_Armor
@property (copy, nonatomic) NSString *SlotText;

// 后期生成的属性
@property (copy, nonatomic) NSString *name_loc;

@end
