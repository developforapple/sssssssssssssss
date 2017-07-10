//
//  SPInventoryCategoryPickerVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPlayerCommon.h"

@interface SPInventoryCategoryPickerVC : UIViewController

@property (strong, nonatomic) NSArray *categoryTitles;
@property (assign, readonly, getter=isVisible, nonatomic) BOOL visible;

@property (copy, nonatomic) void (^didSelectedCategory)(SPInventoryCategory type);

- (void)show;
- (void)dismiss;

- (NSString *)titleForCategory:(SPInventoryCategory )type;

@end
