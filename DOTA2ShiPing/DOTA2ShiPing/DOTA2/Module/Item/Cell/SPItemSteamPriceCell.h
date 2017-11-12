//
//  SPItemSteamPriceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/8.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPMarketItem;

YG_EXTERN NSString *const kSPItemSteamPriceCell;

@interface SPItemSteamPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemQtyLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemPriceBtn;

@property (strong, nonatomic) SPMarketItem *itemPrice;
- (void)configureWithPrice:(SPMarketItem *)itemPrice;

@end
