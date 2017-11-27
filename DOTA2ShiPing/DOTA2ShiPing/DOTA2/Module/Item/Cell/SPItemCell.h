//
//  SPItemCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "SPItemCommon.h"
#import "YGLineView.h"
#import "SPItemCellModel.h"

@class SPItem;
@class SPPlayerInventoryItemDetail;

#define kSPItemCellLarge @"SPItemCellLarge"
#define kSPItemCellNormal @"SPItemCellNormal"

@interface SPItemCell : SPCollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backColorView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTypeLabel;

// for grid
@property (weak, nonatomic) IBOutlet YGLineView *leftLine;

@property (strong, nonatomic) SPItemCellModel *model;

// 预加载。配置内容。生成各个图层。显示图层默认内容
- (void)preload:(SPItemCellModel *)cellModel;
// cell将要显示在屏幕上。加载图片
- (void)willDisplay;
// cell显示在屏幕上。
- (void)display;

@end
