//
//  UIScrollView+yg_IBInspectable.m
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/7/5.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import "UIScrollView+yg_IBInspectable.h"

@implementation UIScrollView (yg_IBInspectable)

- (void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)automaticallyAdjustsScrollViewInsets
{
#if iOS11_SDK_ENABLED
    if (iOS11) {
        if (automaticallyAdjustsScrollViewInsets) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }else{
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#endif
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
#if iOS11_SDK_ENABLED
    if (iOS11) {
        return self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAutomatic;
    }
    return NO;
#else
    return NO;
#endif
}

@end
