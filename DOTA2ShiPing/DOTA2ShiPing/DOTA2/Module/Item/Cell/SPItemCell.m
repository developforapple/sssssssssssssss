//
//  SPItemCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemCell.h"
#import "SPItemImageLoader.h"
#import "SPDataManager.h"

#import "SPPlayerItems.h"

@interface SPItemCell ()
@property (strong, nonatomic) UIColor *mainColor;
@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPItemCell

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (self.mode == SPItemListModeTable) {
//        self.gLayer.frame = self.backColorView.bounds;
//    }
//}

//- (void)setMode:(SPItemListMode)mode
//{
//    _mode = mode;
//    if (self.mode == SPItemListModeTable) {
//        self.gLayer.frame = self.backColorView.bounds;
//    }
//}

- (void)configure:(SPItem *)item
{
    _item = item;
    
    if ([item isKindOfClass:[SPPlayerItemDetail class]]) {
        [self loadInventoryItem:(SPPlayerItemDetail *)item];
        return;
    }
    
    [self loadImage];
    
    self.itemNameLabel.text = item.nameWithQualtity;
    
    if ([item.prefab isEqualToString:@"bundle"]) {
        
        NSArray *sets = [[SPDataManager shared] querySetsWithCondition:@"store_bundle=?" values:@[item.name?:@""]];
        SPItemSets *theSet = [sets firstObject];
        if (theSet) {
            self.itemTypeLabel.text = [NSString stringWithFormat:@"%@“%@”",SPLOCAL(@"comp_2129_pg_page_treasureelementlistsub_desc_text",@"contain"),theSet.name_loc];
        }else{
            self.itemTypeLabel.text = @"";
        }
    }else{
        self.itemTypeLabel.text = SPLOCALNONIL(item.item_type_name);// item.item_type_name;
    }
    
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:item.item_rarity];
    self.itemRarityLabel.text = rarity.name_loc;
    
    self.mainColor = item.itemColor;
    
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = self.mainColor;
    }else{
        UIColor *baseColor = RGBColor(120, 120, 120, 1);
        self.gLayer.colors = @[(id)blendColors(baseColor, self.mainColor, .8f).CGColor,
                               (id)blendColors(baseColor, self.mainColor, .2f).CGColor];
    }
}

- (void)loadInventoryItem:(SPPlayerItemDetail *)item
{
    SPPlayerInvertoryItemTag *rarityTag = [item rarityTag];
    
    self.itemNameLabel.text = item.name;
    self.itemRarityLabel.text = rarityTag.name;
    self.itemTypeLabel.text = item.type;
    
    self.itemNameLabel.textColor = self.itemRarityLabel.textColor = self.itemTypeLabel.textColor = [UIColor whiteColor];

    NSString *iconurl = [NSString stringWithFormat:@"http://steamcommunity-a.akamaihd.net/economy/image/%@",item.icon_url];
    
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:placeholderImage(kItemListCellImageSize) options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground];
    
    self.mainColor = rarityTag.tagColor.color;
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = blendColors([UIColor whiteColor], self.mainColor, .5f);
    }
}

- (CAGradientLayer *)gLayer
{
    if (self.mode != SPItemListModeTable) return nil;
    if (!_gLayer) {
        _gLayer = [CAGradientLayer layer];
        _gLayer.frame = self.backColorView.bounds;
        _gLayer.startPoint = CGPointMake(0, .5f);
        _gLayer.endPoint = CGPointMake(1, .5f);
        _gLayer.locations = @[@0,@1];
        [self.backColorView.layer addSublayer:_gLayer];
    }
    return _gLayer;
}

- (void)loadImage
{
    [SPItemImageLoader loadItemImage:self.item type:SPImageTypeNormal imageView:self.itemImageView];
}

@end
