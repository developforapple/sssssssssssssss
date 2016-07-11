//
//  UIView+More.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "UIView+More.h"

@implementation UIView (More)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (!animated) {
        [self setHidden:hidden];
        return;
    }
    
    if (self.hidden == hidden) {
        return;
    }
    
    CGFloat alpha = self.alpha;
    
    if (hidden) {
        
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = alpha;
        }];
        
    }else{
        self.alpha = 0.f;
        self.hidden = NO;
        
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = alpha;
        } completion:^(BOOL finished) {
        }];
        
    }
}

@end
