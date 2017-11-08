//
//  SPItemSteamPriceCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/8.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSteamPriceCell.h"
#import "SPMarketItem.h"

NSString *const kSPItemSteamPriceCell = @"SPItemSteamPriceCell";

@implementation SPItemSteamPriceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)configureWithPrice:(SPMarketItem *)itemPrice
{
    self.itemPrice = itemPrice;
    
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:itemPrice.image]];
    self.itemNameLabel.text = itemPrice.name;
    self.itemPriceLabel.text = itemPrice.price;
}


@end
