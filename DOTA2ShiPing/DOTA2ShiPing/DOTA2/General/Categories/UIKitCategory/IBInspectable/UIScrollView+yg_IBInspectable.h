//
//  UIScrollView+yg_IBInspectable.h
//  CDT
//
//  Created by Jay on 2017/7/5.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (yg_IBInspectable)

//automaticallyAdjustsScrollViewInsets
// iOS11适配使用，其他版本无效
@property (assign, nonatomic) BOOL autoAdjustInsetsNever;

@end
