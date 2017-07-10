//
//  UIScrollView+yg_IBInspectable.m
//  CDT
//
//  Created by Jay on 2017/7/5.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "UIScrollView+yg_IBInspectable.h"

@implementation UIScrollView (yg_IBInspectable)

- (void)setAutoAdjustInsetsNever:(BOOL)autoAdjustInsetsNever
{
#if iOS11_SDK_ENABLED
    if (iOS11) {
        if (autoAdjustInsetsNever) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
#endif
}

- (BOOL)autoAdjustInsetsNever
{
#if iOS11_SDK_ENABLED
    if (iOS11) {
        return self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever;
    }
    return NO;
#else
    return NO;
#endif
}

@end
