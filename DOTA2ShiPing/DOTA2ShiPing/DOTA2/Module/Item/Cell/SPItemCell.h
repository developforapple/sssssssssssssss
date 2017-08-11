//
//  SPItemCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPItemCommon.h"
#import "YGLineView.h"

@class SPItem;
@class SPPlayerInventoryItemDetail;

#define kSPItemCellLarge @"SPItemCellLarge"
#define kSPItemCellNormal @"SPItemCellNormal"

@interface SPItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backColorView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) CALayer *imageLayer;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeLabel;

// for grid
@property (weak, nonatomic) IBOutlet YGLineView *leftLine;

@property (strong, readonly, nonatomic) id item;
@property (assign, nonatomic) SPItemListMode mode;
@property (assign, nonatomic) CGSize placeholderImageSize;

// Class:SPItem SPPlayerInventoryItemDetail
- (void)configure:(id)item;


@end
