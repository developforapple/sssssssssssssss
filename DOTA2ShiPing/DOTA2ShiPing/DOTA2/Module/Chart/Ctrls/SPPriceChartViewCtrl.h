//
//  SPPriceChartViewCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/28.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPItem;
@class SPMarketItem;

@interface SPPriceChartViewCtrl : YGBaseViewCtrl

@property (strong, nonatomic) SPItem *item;
@property (strong, nonatomic) SPMarketItem *marketItem;

@end
