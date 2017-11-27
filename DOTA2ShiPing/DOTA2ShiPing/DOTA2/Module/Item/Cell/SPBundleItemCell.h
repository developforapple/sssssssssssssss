//
//  SPBundleItemCell.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"

@class SPItem;

YG_EXTERN NSString *const kSPBundleItemCell;

@interface SPBundleItemCell : SPCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIView *moreItemsView;

@property (assign, nonatomic) BOOL isMoreStyle;

@property (strong, nonatomic) SPItem *item;

@end
