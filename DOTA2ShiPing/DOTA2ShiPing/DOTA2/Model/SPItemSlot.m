//
//  SPItemSlot.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/15.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemSlot.h"
#import "YYModel.h"


@implementation SPItemSlot
YYModelDefaultCode

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",[super description],_SlotName,_name_loc];
}

@end
