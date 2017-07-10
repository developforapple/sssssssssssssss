//
//  UIActivityIndicatorView+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIActivityIndicatorView+yg_IBInspectable.h"

@implementation UIActivityIndicatorView (yg_IBInspectable)
- (BOOL)animating_
{
    return self.isAnimating;
}

- (void)setAnimating_:(BOOL)animating_
{
    if (animating_) {
        [self startAnimating];
    }else{
        [self stopAnimating];
    }
}
@end
