//
//  SPItemPriceListViewCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPItem.h"

@interface SPItemPriceListViewCtrl : YGBaseViewCtrl

@property (copy, nonatomic) void (^heightDidChanged)(CGFloat height);

@property (strong, nonatomic) SPItem *item;

@end
