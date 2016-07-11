//
//  SPSearchPlayerItemsVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPPlayer;

@interface SPSearchPlayerItemsVC : UIViewController

/**
 *  为nil时搜索所有的库存。
 */
@property (strong, nonatomic) SPPlayer *player;

- (void)search:(NSString *)keywords;

@end
