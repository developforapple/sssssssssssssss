//
//  SPItemPriceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/27.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPMarketItem;

YG_EXTERN NSString *const kSPItemPriceCell;

@interface SPItemPriceCell : UITableViewCell

@property (strong, readonly, nonatomic) SPMarketItem *item;
- (void)configureWithItem:(SPMarketItem *)item;

@end
