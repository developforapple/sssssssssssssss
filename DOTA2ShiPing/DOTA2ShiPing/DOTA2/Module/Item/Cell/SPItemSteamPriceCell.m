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

NSString *const kSPItemSteamPriceCell = @"SPItemSteamPriceCell";

@interface SPItemSteamPriceCell ()
@property (weak, nonatomic) IBOutlet UIView *backColorView;
@property (strong, nonatomic) CAGradientLayer *gLayer;
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
    self.itemPriceLabel.text = itemPrice.price;
    self.itemQtyLabel.text = [@"x " stringByAppendingString:itemPrice.qty];
    
    [self.itemPriceBtn setTitle:itemPrice.price forState:UIControlStateNormal];
    
    if (!_gLayer) {
        _gLayer = [CAGradientLayer layer];
        _gLayer.frame = self.backColorView.bounds;
        _gLayer.startPoint = CGPointMake(0, .5f);
        _gLayer.endPoint = CGPointMake(1, .5f);
        _gLayer.locations = @[@0,@1];
        [_backColorView.layer addSublayer:_gLayer];
    }
    
    UIColor *baseColor = RGBColor(120, 120, 120, 1);
    NSArray *colors =  @[(id)blendColors(baseColor, itemPrice.color.color, .8f).CGColor,
                         (id)blendColors(baseColor, itemPrice.color.color, .2f).CGColor];
    _gLayer.colors = colors;
}

- (IBAction)steamWebsiteAction:(id)sender
{
    NSURLComponents *compontents = [NSURLComponents componentsWithString:self.itemPrice.href];
    compontents.queryItems = nil;
    [SPWebHelper openURL:compontents.URL from:[self viewController]];
}


@end
