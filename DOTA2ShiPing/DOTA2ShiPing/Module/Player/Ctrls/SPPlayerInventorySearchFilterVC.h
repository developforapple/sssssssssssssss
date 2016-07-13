//
//  SPPlayerInventorySearchFilterVC.h
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/12.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPInventoryFilter.h"

@class SPInventoryFilterCondition;

// 筛选项
@interface SPPlayerInventorySearchFilterVC : UITableViewController

@property (strong, nonatomic) SPInventoryFilter *filter;

@property (copy, nonatomic) void (^willShowFilterResult)(void);

@end
