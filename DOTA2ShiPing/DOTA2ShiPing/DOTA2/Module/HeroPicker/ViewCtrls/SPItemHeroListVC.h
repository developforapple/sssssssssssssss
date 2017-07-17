//
//  SPItemHeroListVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPHero.h"

@interface SPItemHeroListVC : YGBaseViewCtrl
@property (strong, nonatomic) NSArray<NSString *> *history;
@property (assign, nonatomic) SPHeroType type;
@property (copy, nonatomic) void (^didSelectedHero)(SPHero *hero);
- (void)reloadData;
@end
