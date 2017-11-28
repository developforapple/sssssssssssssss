//
//  SPItemsDetailViewCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPItem;
@class SPPlayerItemDetail;

@interface SPItemsDetailViewCtrl : YGBaseViewCtrl
@property (strong, nonatomic) SPItem *item;
@property (strong, nonatomic) SPPlayerItemDetail *playerItem;

@end
