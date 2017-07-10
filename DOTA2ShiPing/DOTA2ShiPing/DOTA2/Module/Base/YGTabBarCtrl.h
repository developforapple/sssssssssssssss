//
//  YGTabBarCtrl.h
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, BingoTabType) {
    // 对应tab的索引值
    BingoTabTypeHome = 0,
};

#ifndef DefaultTabBarCtrl
    #define DefaultTabBarCtrl [YGTabBarCtrl defaultTabBarCtrl]
#endif

#ifndef BingoCurNaviCtrl
    #define BingoCurNaviCtrl [DefaultTabBarCtrl navigationOfTab:(BingoTabType)[DefaultTabBarCtrl selectedIndex]]
#endif

#ifndef BingoHomeNaviCtrl
    #define BingoHomeNaviCtrl [DefaultTabBarCtrl navigationOfTab:BingoTabTypeHome]
#endif

#ifndef BingoMallNaviCtrl
    #define BingoMallNaviCtrl [DefaultTabBarCtrl navigationOfTab:BingoTabTypeMall]
#endif

#ifndef BingoPowerNaviCtrl
    #define BingoPowerNaviCtrl [DefaultTabBarCtrl navigationOfTab:BingoTabTypePower]
#endif

#ifndef BingoRentNaviCtrl
    #define BingoRentNaviCtrl [DefaultTabBarCtrl navigationOfTab:BingoTabTypeRent]
#endif

#ifndef BingoMineNaviCtrl
    #define BingoMineNaviCtrl [DefaultTabBarCtrl navigationOfTab:BingoTabTypeMine]
#endif

@interface YGTabBarCtrl : UITabBarController

+ (instancetype)defaultTabBarCtrl;

- (UINavigationController *)navigationOfTab:(BingoTabType)type;

@end
