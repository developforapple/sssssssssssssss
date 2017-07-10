//
//  SPPlayerInventorySearchResultVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPItemCommon.h"

@class SPInventoryFilter;

// 显示搜索结果
@interface SPPlayerInventorySearchResultVC : UIViewController <UISearchResultsUpdating,UISearchBarDelegate>

@property (strong, nonatomic) SPInventoryFilter *filter;

@property (assign, nonatomic) SPItemListMode mode;

@property (weak, nonatomic) UISearchController *searchCtrl;

@property (copy, nonatomic) void (^willShowFilteredResult)(void);

@end
