//
//  SPItemHeroPickerVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPHero;

@interface SPItemHeroPickerVC : SPBaseViewController

// 如果为NULL，则打开英雄饰品列表页。否则，使用block回调
@property (copy, nonatomic) void (^didSelectedHero)(SPHero *hero);

@end