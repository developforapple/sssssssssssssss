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


@interface SPItemListContainer ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

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
    [self updateWithMode:self.mode];
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    if (self.topInset) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        insets.top = self.topInset.floatValue;
        self.collectionView.contentInset = insets;
    }
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
            self.flowlayout.itemSize = CGSizeMake(Device_Width, 64);
            self.flowlayout.sectionInset = UIEdgeInsetsZero;
            self.flowlayout.minimumLineSpacing = 0;
            self.flowlayout.minimumInteritemSpacing = 0;
        }   break;
        case SPItemListModeGrid:{
            CGFloat width;
            CGFloat height;
            CGFloat insetL;
            CGFloat insetR;
            CGFloat sp;
            
            insetL = .5f;
            insetR = .5f;
            sp = .5f;
            width = (Device_Width - 5 * .5f)/4.f;
            height = ceilf(width /1.5f) + 20.f;
            
            self.flowlayout.itemSize = CGSizeMake(width, height);
            self.flowlayout.sectionInset =  UIEdgeInsetsMake(insetL, insetL, 0.f, insetR);
            self.flowlayout.minimumLineSpacing = sp;
            self.flowlayout.minimumInteritemSpacing = 0.f;
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
