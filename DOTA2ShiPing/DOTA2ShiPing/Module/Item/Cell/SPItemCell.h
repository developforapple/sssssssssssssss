//
//  SPItemCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPItemCommon.h"

@class SPItem;
@class SPPlayerInventoryItemDetail;

#define kSPItemCellLarge @"SPItemCellLarge"
#define kSPItemCellNormal @"SPItemCellNormal"

@interface SPItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backColorView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeLabel;

@property (strong, readonly, nonatomic) id item;

@property (assign, nonatomic) SPItemListMode mode;

// Class:SPItem SPPlayerInventoryItemDetail
- (void)configure:(id)item;

@end
