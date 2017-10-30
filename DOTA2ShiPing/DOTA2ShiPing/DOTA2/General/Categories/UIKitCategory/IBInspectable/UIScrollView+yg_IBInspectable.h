//
//  UIScrollView+yg_IBInspectable.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/7/5.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (yg_IBInspectable)

// iOS11适配使用，其他版本无效
@property (assign, nonatomic) BOOL automaticallyAdjustsScrollViewInsets;

@end
