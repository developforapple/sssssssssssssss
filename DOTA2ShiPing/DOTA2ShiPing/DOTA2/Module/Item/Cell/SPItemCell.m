//
//  SPItemCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemCell.h"
#import "SPItem+Cache.h"
#import "YYWebImage.h"
#import "SPDataManager.h"

#import "SPPlayerItems.h"

UIImage *placeholderImage(){
    static UIImage *img;
    if (!img) img = [UIImage imageNamed:@"HeroPlacehodler"];
    return img;
}

@interface SPItemCell ()
@property (strong, nonatomic) CALayer *lineLayer;
@property (strong, nonatomic) SPItemColor *mainColor;
@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPItemCell

- (void)dealloc
{
    NSLog(@"%@释放",NSStringFromClass([self class]));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.mode == SPItemListModeTable) {
        self.lineLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-.5f, CGRectGetWidth(self.frame), .5f);
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
    
    self.itemNameLabel.text = item.item_name;
    
    if ([item.prefab isEqualToString:@"bundle"]) {
        
        NSArray *sets = [[SPDataManager shared] querySetsWithCondition:@"store_bundle=?" values:@[item.name?:@""]];
        SPItemSets *theSet = [sets firstObject];
        if (theSet) {
            self.itemTypeLabel.text = [NSString stringWithFormat:@"包含“%@”",theSet.name_cn];
        }else{
            self.itemTypeLabel.text = @"";
        }
    }else{
        self.itemTypeLabel.text = item.item_type_name;
    }
    
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:item.item_rarity];
    self.itemRarityLabel.text = rarity.name_cn;
    
    SPItemColor *color = [[SPDataManager shared] colorOfName:rarity.color];
    self.mainColor = color;
    
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = [color blendColorWithAlpha:0.5f baseColor:nil];
    }
}

- (void)loadInventoryItem:(SPPlayerItemDetail *)item
{
    SPPlayerInvertoryItemTag *rarityTag = [item rarityTag];
    
    self.itemNameLabel.text = item.name;
    self.itemRarityLabel.text = rarityTag.name;
    self.itemTypeLabel.text = item.type;

    NSString *iconurl = [NSString stringWithFormat:@"http://steamcommunity-a.akamaihd.net/economy/image/%@",item.icon_url];
    
    [self.itemImageView yy_setImageWithURL:[NSURL URLWithString:iconurl] placeholder:placeholderImage() options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    self.mainColor = rarityTag.tagColor;
    if (self.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = [self.mainColor blendColorWithAlpha:.5f baseColor:nil];
    }
}

- (CALayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = RGBColor(200, 200, 200, 1).CGColor;
        [self.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
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
        _gLayer.colors = @[(id)[self.mainColor blendColorWithAlpha:.5f baseColor:nil].CGColor,
                           (id)[self.mainColor blendColorWithAlpha:.1f baseColor:nil].CGColor];
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
    NSURL *qiniuURL = [self.item qiniuImageURL];
    NSUInteger hash = qiniuURL.hash;
    // 加载七牛的图片
    
    ygweakify(self);
    
    [self.itemImageView yy_setImageWithURL:qiniuURL placeholder:placeholderImage() options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        NSUInteger hash2 = hash;
        if (hash2 == url.hash) {
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
            
            [self.itemImageView yy_setImageWithURL:url placeholder:placeholderImage() options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionAvoidSetImage completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
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
