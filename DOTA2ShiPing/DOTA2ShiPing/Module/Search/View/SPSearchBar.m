//
//  SPSearchBar.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/28.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSearchBar.h"
#import "SPMacro.h"

@implementation SPSearchBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *a = @"archBarBa";
    NSString *backgroundClassName = [NSString stringWithFormat:@"UISe%@ckground",a];
    Class class = NSClassFromString(backgroundClassName);
    
    for (UIView *view in [self.subviews firstObject].subviews) {
        if ([view isKindOfClass:[class class]]) {
            view.alpha = 0.f;
        }else if([view isKindOfClass:[UITextField class]]){
            [(UITextField *)view setTintColor:AppBarColor];
        }
    }
}



@end
