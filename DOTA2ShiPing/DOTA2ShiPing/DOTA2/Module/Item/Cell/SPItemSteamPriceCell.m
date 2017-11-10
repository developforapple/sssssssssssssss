//
//  SPItemSteamPriceCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/8.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSteamPriceCell.h"
#import "SPMarketItem.h"
#import "SPWebHelper.h"

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
    self.itemQtyLabel.text = [@"x " stringByAppendingString:itemPrice.qty];
    
    self.itemImageView.borderColor_ = itemPrice.color;
    self.itemImageView.borderWidth_ = 1;
    
    [self.itemPriceBtn setTitle:itemPrice.price forState:UIControlStateNormal];
}

- (IBAction)steamWebsiteAction:(id)sender
{
    [SPWebHelper openURL:[NSURL URLWithString:self.itemPrice.href] from:[self viewController]];
}


@end
