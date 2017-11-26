//
//  SPFilterNaviCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterNaviCtrl.h"
#import "SPFilterViewCtrl.h"

@interface SPFilterNaviCtrl ()

@end

@implementation SPFilterNaviCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SPFilterViewCtrl *vc = [self viewControllers].firstObject;
    vc.filter = self.filter;
}

@end
