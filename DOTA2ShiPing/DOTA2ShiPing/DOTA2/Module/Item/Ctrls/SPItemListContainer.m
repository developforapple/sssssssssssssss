//
//  SPItemListContainer.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemListContainer.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SPLogoHeader.h"
#import "SPItemCell.h"
#import "SPItemsDetailViewCtrl.h"
#import "SPItemImageLoader.h"

@interface SPItemListContainer ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
//@property (strong, nonatomic) UICollectionViewFlowLayout *tableLayout;

@end

@implementation SPItemListContainer

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.scrollsToTop = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.collectionView.scrollsToTop = NO;
}

- (void)initUI
{
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    if (self.topInset) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        insets.top = self.topInset.floatValue;
        self.collectionView.contentInset = insets;
    }
    
    [self updateWithMode:self.mode];
}

- (void)setupClearBackground
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)updateWithMode:(SPItemListMode)mode
{
    switch (mode) {
        case SPItemListModeTable:{
            
            [SPItemImageLoader setItemListCellImageSize:CGSizeMake(90, 60)];
            
            self.flowlayout.itemSize = CGSizeMake(Device_Width, 64);
            self.flowlayout.sectionInset = UIEdgeInsetsZero;
            self.flowlayout.minimumLineSpacing = 0.f;
            self.flowlayout.minimumInteritemSpacing = 0.f;
        }   break;
        case SPItemListModeGrid:{
            
            CGFloat width = 0.f;
            CGFloat height = 0.f;
            UIEdgeInsets sectionInset;
            CGFloat itemSpacing = 0.f;
            CGFloat lineSpacing = 0.5f;
            
            width = floorf(Device_Width/4);
            height = ceilf(width/1.5f + 20.f);
            CGFloat margin = (Device_Width - width * 4 ) /2;
            sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
            
            [SPItemImageLoader setItemListCellImageSize:CGSizeMake(width, height)];
            
            self.flowlayout.itemSize = CGSizeMake(width, height);
            self.flowlayout.sectionInset = sectionInset;
            self.flowlayout.minimumLineSpacing = lineSpacing;
            self.flowlayout.minimumInteritemSpacing = itemSpacing;
            
        }    break;
    }
    if (self.mode != mode) {
        self.mode = mode;
        [self.collectionView reloadData];
    }
}

- (void)setItems:(NSArray<SPItem *> *)items
{
    if (_items != items) {
        _items = items;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.mode==SPItemListModeGrid?kSPItemCellNormal:kSPItemCellLarge;
    SPItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.mode = self.mode;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPItemCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItem *item = self.items[indexPath.row];
    [cell configure:item];
    
    if (cell.mode == SPItemListModeGrid) {
        BOOL isFirstItemOfLine = indexPath.row % 4 == 0;
        cell.leftLine.hidden = isFirstItemOfLine;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItem *item = self.items[indexPath.row];
    SPItemsDetailViewCtrl *vc = [SPItemsDetailViewCtrl instanceFromStoryboard];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.emptyDataNote) {
        return self.emptyDataNote;
    }
    return [[NSAttributedString alloc] initWithString:@"没有内容" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.items.count==0;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

@end
