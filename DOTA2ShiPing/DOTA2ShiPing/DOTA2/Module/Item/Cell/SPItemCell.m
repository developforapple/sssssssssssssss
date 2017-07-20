//
//  SPItemCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemCell.h"
#import "SPItem+Cache.h"
#import "SPDataManager.h"

#import "SPPlayerItems.h"

UIImage *placeholderImage(){
    static UIImage *img;
    if (!img) img = [UIImage imageNamed:@"HeroPlacehodler"];
    return img;
}

@interface SPItemCell ()
@property (strong, nonatomic) SPItemColor *mainColor;
@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPItemCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.mode == SPItemListModeTable) {
        self.gLayer.frame = self.backColorView.bounds;
    }
}

- (void)configure:(SPItem *)item
{
    _item = item;
    
    if ([item isKindOfClass:[SPPlayerItemDetail class]]) {
        [self loadInventoryItem:(SPPlayerItemDetail *)item];
        return;
    }
    
    [self loadImage];
    
    self.itemNameLabel.text = SPLOCALNONIL(item.item_name);//  item.item_name;
    
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
    
    SPItemColor *color = [[SPDataManager shared] colorOfName:rarity.color];
    self.mainColor = color;
    
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = color.color;
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
    
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:placeholderImage() options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageContinueInBackground];
    
    self.mainColor = rarityTag.tagColor;
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = [self.mainColor blendColorWithAlpha:.5f baseColor:nil];
    }
}

- (CAGradientLayer *)gLayer
{
    if (!_gLayer) {
        _gLayer = [CAGradientLayer layer];
        if (self.mode == SPItemListModeTable) {
            _gLayer.startPoint = CGPointMake(0, .5f);
            _gLayer.endPoint = CGPointMake(1, .5f);
            _gLayer.locations = @[@0,@1];
            [self.backColorView.layer addSublayer:_gLayer];
        }
    }
    if (self.mode == SPItemListModeTable){
//        _gLayer.colors = @[(id)[self.mainColor blendColorWithAlpha:.8f baseColor:nil].CGColor,
//                           (id)[self.mainColor blendColorWithAlpha:.4f baseColor:nil].CGColor];
        
        UIColor *baseColor = RGBColor(120, 120, 120, 1);
        _gLayer.colors = @[(id)[self.mainColor blendColorWithAlpha:.8f baseColor:baseColor].CGColor,
                           (id)[self.mainColor blendColorWithAlpha:.2f baseColor:baseColor].CGColor];
    }
    return _gLayer;
}

- (SPItemColor *)mainColor
{
    if (!_mainColor) {
        _mainColor = [SPItemColor new];
        _mainColor.hex_color = @"#ffffff";
    }
    return _mainColor;
}

- (void)loadImage
{
    NSURL *qiniuURL = [self.item qiniuSmallURL];
    NSUInteger hash = qiniuURL.hash;
    // 加载七牛的图片
    
    ygweakify(self);
    
    [self.itemImageView sd_setImageWithURL:qiniuURL placeholderImage:placeholderImage() options:SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSUInteger hash2 = hash;
        if (hash2 == imageURL.hash) {
            ygstrongify(self);
            if (!error && image) {
                self.itemImageView.image = image;
            }else{
                [self loadOriginImage];
            }
        }
    }];
}

- (void)loadOriginImage
{
    // 获取原始图片
    ygweakify(self);
    [self.item getItemImageInventory:^(id content) {
        ygstrongify(self);
        RunOnMainQueue(^{
            NSURL *url = [NSURL URLWithString:content];
            NSUInteger hash = url.hash;
            
            [self.itemImageView sd_setImageWithURL:url placeholderImage:placeholderImage() options:SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageLowPriority | SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                ygstrongify(self);
                if (!error && image) {
                    NSUInteger hash2 = hash;
                    if (url.hash == hash2) {
                        self.itemImageView.image = image;
                    }
                }
            }];
        });
    }];
}

@end
