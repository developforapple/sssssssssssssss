//
//  SPItemHeroPickerVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPHero;

typedef BOOL (^SPHeroPickerCallbackBlock)(SPHero *hero);

@interface SPItemHeroPickerVC : YGBaseViewCtrl

// 弹出英雄选择。带导航栏。左侧为取消按钮。
+ (void)presentFrom:(UIViewController *)vc
   selectedCallback:(SPHeroPickerCallbackBlock)callback;

+ (void)bePushingIn:(UINavigationController *)navi
   selectedCallback:(SPHeroPickerCallbackBlock)callback;

// 选择英雄时的回调。外部返回BOOL值标识是否隐藏英雄选择器。
@property (copy, nonatomic) SPHeroPickerCallbackBlock didSelectedHero;
@end
