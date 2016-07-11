//
//  SPInventorySegmentPickerVC.h
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPInventorySegmentPickerVC : UIViewController

@property (strong, nonatomic) NSArray *titles;
@property (assign, nonatomic) NSUInteger currentIndex;

@property (assign, readonly, getter=isVisible, nonatomic) BOOL visible;

@property (copy, nonatomic) void (^didSelectedIndex)(NSUInteger index);

- (void)show;
- (void)dismiss;

@end
