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

@import ChameleonFramework;

@interface SPItemCell ()

// 作为占位图的图层，总是存在于grid模式，避免cell刷新图片时重设一次placeholder图片
@property (strong, nonatomic) CALayer *placeholderImageLayer;
@property (strong, nonatomic) CALayer *imageLayer;
@property (strong, nonatomic) CATextLayer *nameLayer;

@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPItemCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (_imageLayer) {
        _imageLayer.contents = nil;
        _imageLayer.hidden = YES;
    }
}

- (CALayer *)createImageLayer
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, _model.preferImageSize.width, _model.preferImageSize.height);
    imageLayer.contentsScale = Screen_Scale;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    imageLayer.masksToBounds = YES;
    imageLayer.opaque = YES;
    imageLayer.opacity = 1.f;
    imageLayer.drawsAsynchronously = YES;
    return imageLayer;
}

- (void)preload:(SPItemCellModel *)cellModel
{
    self.model = cellModel;
    SPItem *item = _model.item;
    
    if (_model.mode == SPItemListModeGrid) {
        
//        if (!_placeholderImageLayer) {
//            // 生成默认图片图层
//            _placeholderImageLayer = [self createImageLayer];
//            _placeholderImageLayer.contents = (__bridge id _Nullable)(placeholderImage(_model.preferImageSize).CGImage);
//            [self.contentView.layer insertSublayer:_placeholderImageLayer atIndex:0];
//        }
        
        if (!_imageLayer) {
            // 生成图片图层
            _imageLayer = [self createImageLayer];
            _imageLayer.hidden = YES;
//            [self.contentView.layer insertSublayer:_imageLayer above:_placeholderImageLayer];
            [self.contentView.layer insertSublayer:_imageLayer atIndex:0];
        }
        
        if (!_nameLayer) {
            _nameLayer = [CATextLayer layer];
            _nameLayer.wrapped = YES;
            _nameLayer.truncationMode = kCATruncationNone;
            _nameLayer.alignmentMode = kCAAlignmentCenter;
            _nameLayer.contentsScale = Screen_Scale;
            _nameLayer.masksToBounds = YES;
            [self.contentView.layer insertSublayer:_nameLayer above:_imageLayer];
        }

        self.contentView.backgroundColor = item.itemColor;
        
    }else if (_model.mode == SPItemListModeTable){
    
        if (!_gLayer) {
            _gLayer = [CAGradientLayer layer];
            _gLayer.frame = CGRectMake(0, 0, Device_Width, CGRectGetHeight(self.backColorView.bounds));
            _gLayer.startPoint = CGPointMake(0, .5f);
            _gLayer.endPoint = CGPointMake(1, .5f);
            _gLayer.locations = @[@0,@1];
            [_backColorView.layer addSublayer:_gLayer];
        }
    }
    
    _leftLine.hidden = _model.lineHidden;
}

- (void)willDisplay
{
    SPItem *item = _model.item;
    
    if ([item isKindOfClass:[SPPlayerItemDetail class]]) {
        [self loadInventoryItem:(SPPlayerItemDetail *)item];
        return;
    }
    
    if (self.itemImageView) {
        [SPItemImageLoader loadItemImage:item size:_model.preferImageSize type:SPImageTypeNormal imageView:_itemImageView];
    }else{
        _imageLayer.hidden = YES;
        [SPItemImageLoader loadItemImage:item size:kNonePlaceholderSize type:SPImageTypeNormal layer:_imageLayer];
    }
    
    if (self.nameLayer) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _nameLayer.bounds = CGRectMake(0, 0, _model.nameSize.width-4.f, _model.nameSize.height);
        _nameLayer.position = _model.namePosition;
        _nameLayer.string = _model.name;
        _nameLayer.backgroundColor = self.contentView.backgroundColor.CGColor;
        [CATransaction commit];
    }
    
    if (self.itemNameLabel) {
        self.itemNameLabel.text = item.nameWithQualtity;
    }
    
    if (self.itemTypeLabel) {
        self.itemTypeLabel.text = _model.typeString;
    }
    
    if (self.itemRarityLabel) {
        self.itemRarityLabel.text = _model.rarityString;
    }
    
    if (_model.mode == SPItemListModeTable) {
        self.gLayer.colors = _model.gradientColors;
    }
}

- (void)display
{
    
}

- (void)loadInventoryItem:(SPPlayerItemDetail *)item
{
    SPPlayerInvertoryItemTag *rarityTag = [item rarityTag];
    
    self.itemNameLabel.text = item.name;
    self.itemRarityLabel.text = rarityTag.name;
    self.itemTypeLabel.text = item.type;
    
    self.itemNameLabel.textColor = self.itemRarityLabel.textColor = self.itemTypeLabel.textColor = [UIColor whiteColor];

//    NSString *iconurl = [NSString stringWithFormat:@"http://steamcommunity-a.akamaihd.net/economy/image/%@",item.icon_url];
//    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:placeholderImage(kItemListCellImageSize) options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground];
    
    if (_model.mode == SPItemListModeGrid) {
        self.itemNameLabel.backgroundColor = blendColors([UIColor whiteColor], rarityTag.tagColor.color, .5f);
    }
}

@end
