//
//  SPBundleItemCell.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBundleItemCell.h"
#import "SPItem.h"
#import "SPItemImageLoader.h"

NSString *const kSPBundleItemCell = @"SPBundleItemCell";

@implementation SPBundleItemCell

- (void)setItem:(SPItem *)item
{
    _item = item;
    
    [SPItemImageLoader loadItemImage:item size:kNonePlaceholderSize type:SPImageTypeNormal imageView:self.itemImageView];
    self.itemNameLabel.text = item.nameWithQualtity;
    self.contentView.backgroundColor = item.itemColor;
}

@end
