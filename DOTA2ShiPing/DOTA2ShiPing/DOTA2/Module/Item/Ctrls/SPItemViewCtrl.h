//
//  SPItemViewCtrl.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPItem;
@class SPPlayerItemDetail;

@interface SPItemViewCtrl : YGBaseViewCtrl

@property (strong, nonatomic) SPItem *item;
@property (strong, nonatomic) SPPlayerItemDetail *playerItem;

@end
