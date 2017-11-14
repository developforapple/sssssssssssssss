//
//  SPItemMoreItemsView.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemMoreItemsView.h"
#import "SPItemSharedData.h"
#import "SPBundleItemCell.h"
#import "SPItemsDetailViewCtrl.h"
@import ChameleonFramework;
#import "SPItemListVC.h"

// 一行显示多少个物品
static const NSInteger kItemsPerLine = 3;
// 最大多少行
static const NSInteger kMaxLines = 3;
// 最多显示多少个物品
static const NSInteger kMaxItems = 3 * 3;

@interface SPItemMoreItemsView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemsView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zeroHeightConstraint;
@property (assign, nonatomic) SPItemListMode mode;
@property (strong, nonatomic) NSArray<SPItem *> *items;
@end

@implementation SPItemMoreItemsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI
{
    self.mode = SPItemListModeGrid;
    
    [self.superview layoutIfNeeded];
    CGFloat containerWidth = CGRectGetWidth(self.itemsView.frame);

    CGFloat width = 0.f;
    CGFloat height = 0.f;
    UIEdgeInsets sectionInset;
    CGFloat itemSpacing = 0.f;
    CGFloat lineSpacing = 0.f;
    
    width = floorf(containerWidth/kItemsPerLine);
    height = ceilf(width/1.5f + 20.f);
    CGFloat margin = (containerWidth - width * kItemsPerLine );
    sectionInset = UIEdgeInsetsMake(0, 0, 0, margin);
    
    self.itemsView.contentInset = UIEdgeInsetsZero;
    self.layout.itemSize = CGSizeMake(width, height);
    self.layout.sectionInset = sectionInset;
    self.layout.minimumLineSpacing = lineSpacing;
    self.layout.minimumInteritemSpacing = itemSpacing;
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self initUI];
    [self update];
}

- (void)update
{
    if (self.itemData.bundleItems.count == 0 && self.itemData.lootList.count == 0) {
        self.zeroHeightConstraint.priority = 999;
        [self setNeedsLayout];
        return;
    }
    
    NSString *title;
    NSArray *items;
    if (self.itemData.bundleItems.count) {
        items = self.itemData.bundleItems;
        title = self.itemData.itemSet.name_loc;
    }else if (self.itemData.lootList.count){
        items = self.itemData.lootList;
    }
    if (title.length > 0) {
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:self.titleLabel.font,NSForegroundColorAttributeName:self.titleLabel.textColor}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" 包含物品:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:FlatGrayDark}]];
        self.titleLabel.attributedText = text;
    }else{
        self.titleLabel.text = @"包含物品";
    }
        
    self.items = items;
    [UIView animateWithDuration:.1f animations:^{
        [self.itemsView reloadData];
    } completion:^(BOOL finished) {
        CGFloat h = self.itemsView.contentSize.height;
        self.itemsViewHeightConstraint.constant = h;
        [self layoutIfNeeded];
    }];
}

- (BOOL)isItemCellIsMoreStyle:(NSIndexPath *)indexPath
{
    return indexPath.item == kMaxItems - 1 && self.items.count > kMaxItems;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(kMaxItems, self.items.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = kSPBundleItemCell;
    SPBundleItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.item = self.items[indexPath.item];
    cell.isMoreStyle = [self isItemCellIsMoreStyle:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isItemCellIsMoreStyle:indexPath]) {
        // 显示更多
        SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
        vc.filter = [SPItemFilter importItems:self.items];
        vc.filter.filterTitle = self.itemData.item.nameWithQualtity;
        [[[self viewController] navigationController] pushViewController:vc animated:YES];
        return;
    }
    
    SPItem *item = self.items[indexPath.row];
    SPItemsDetailViewCtrl *vc = [SPItemsDetailViewCtrl instanceFromStoryboard];
    vc.item = item;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
