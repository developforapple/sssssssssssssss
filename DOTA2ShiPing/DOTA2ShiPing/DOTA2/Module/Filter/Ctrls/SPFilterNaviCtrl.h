//
//  SPFilterNaviCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseNaviCtrl.h"

@class SPBaseFilter;

@interface SPFilterNaviCtrl : YGBaseNaviCtrl

@property (strong, nonatomic) __kindof SPBaseFilter *filter;

@end
