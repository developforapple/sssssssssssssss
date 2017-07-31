//
//  SPItemPriceCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/27.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPriceCell.h"
#import "SPMarketItem.h"

NSString *const kSPItemPriceCell = @"SPItemPriceCell";

@interface SPItemPriceCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (strong, readwrite, nonatomic) SPMarketItem *item;
@end

@implementation SPItemPriceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)configureWithItem:(SPMarketItem *)item
{
    self.item = item;
    
    self.itemNameLabel.text = item.name;
    self.itemPriceLabel.text = item.price;
}

@end
