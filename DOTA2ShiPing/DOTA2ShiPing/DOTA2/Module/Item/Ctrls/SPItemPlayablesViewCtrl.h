//
//  SPItemPlayablesViewCtrl.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPGamepediaPlayable.h"

@interface SPItemPlayablesViewCtrl : YGBaseViewCtrl

@property (strong, nonatomic) NSArray<SPGamepediaPlayable *> *playables;

@end
