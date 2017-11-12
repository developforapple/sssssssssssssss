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
#import "SPItemColor.h"

@import ChameleonFramework;

NSString *const kSPItemSteamPriceCell = @"SPItemSteamPriceCell";

@interface SPItemSteamPriceCell ()

@end

@implementation SPItemSteamPriceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    
}

- (void)configureWithPrice:(SPMarketItem *)itemPrice
{
    self.itemPrice = itemPrice;
    
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:itemPrice.image]];
    self.itemNameLabel.text = itemPrice.name;
    self.itemQtyLabel.text = [@"x " stringByAppendingString:itemPrice.qty];
    [self.itemPriceBtn setTitle:itemPrice.price forState:UIControlStateNormal];
}

- (IBAction)steamWebsiteAction:(id)sender
{
    NSURLComponents *compontents = [NSURLComponents componentsWithString:self.itemPrice.href];
    compontents.queryItems = nil;
    [SPWebHelper openURL:compontents.URL from:[self viewController]];
}


@end
