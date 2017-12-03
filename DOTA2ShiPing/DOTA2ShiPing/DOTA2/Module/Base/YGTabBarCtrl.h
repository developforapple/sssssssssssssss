//
//  YGTabBarCtrl.h
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, SPTabType) {
    // 对应tab的索引值
    SPTabTypeItem = 0,
    SPTabTypePlayer = 1,
    SPTabTypeWorkshop = 2,
    SPTabTypeMore = 3
};

#ifndef DefaultTabBarCtrl
    #define DefaultTabBarCtrl [YGTabBarCtrl defaultTabBarCtrl]
#endif

#ifndef SPCurNaviCtrl
    #define SPCurNaviCtrl [DefaultTabBarCtrl navigationOfTab:(SPTabType)[DefaultTabBarCtrl selectedIndex]]
#endif

#ifndef SPItemNaviCtrl
    #define SPItemNaviCtrl [DefaultTabBarCtrl navigationOfTab:SPTabTypeItem]
#endif

#ifndef SPPlayerNaviCtrl
    #define SPPlayerNaviCtrl [DefaultTabBarCtrl navigationOfTab:SPTabTypePlayer]
#endif

#ifndef SPWorkshopNaviCtrl
    #define SPWorkshopNaviCtrl [DefaultTabBarCtrl navigationOfTab:SPTabTypeWorkshop]
#endif

#ifndef SPMoreNaviCtrl
    #define SPMoreNaviCtrl [DefaultTabBarCtrl navigationOfTab:SPTabTypeMore]
#endif

@interface YGTabBarCtrl : UITabBarController <UINavigationControllerDelegate>

+ (instancetype)getDefaultTabBarCtrl;

- (UINavigationController *)navigationOfTab:(SPTabType)type;

- (UITabBarItem *)tabBarItemOfTab:(SPTabType)type;

- (void)rootViewControllerDidAppear:(UINavigationController *)navi YG_Abstract_Method;

@end
