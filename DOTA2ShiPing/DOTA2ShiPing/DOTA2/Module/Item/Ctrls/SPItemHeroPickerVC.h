//
//  SPItemHeroPickerVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPHero;

typedef void (^SPHeroPickerCallbackBlock)(SPHero *hero);

@interface SPItemHeroPickerVC : SPBaseViewController

// 弹出英雄选择。带导航栏。左侧为取消按钮。
+ (void)presentFrom:(UIViewController *)vc
   selectedCallback:(SPHeroPickerCallbackBlock)callback;

// 如果为NULL，则打开英雄饰品列表页。否则，使用block回调
@property (copy, nonatomic) SPHeroPickerCallbackBlock didSelectedHero;
@end