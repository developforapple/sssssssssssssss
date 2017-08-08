//
//  SPBundleItemsViewCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/4.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPItem;

@interface SPBundleItemsViewCtrl : YGBaseViewCtrl

@property (copy, nonatomic) void (^heightDidChanged)(CGFloat height);

@property (strong, nonatomic) SPItem *item;

@end
