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
#import "SPItemCellModel.h"

SPItemListMode const kSPItemListModeAuto = 10086;

@interface SPItemListContainer ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
//@property (strong, nonatomic) UICollectionViewFlowLayout *tableLayout;

@property (strong, readwrite, nonatomic) NSArray *items;
@property (assign, nonatomic) CGSize itemImageSize;

@property (strong, nonatomic) NSArray<SPItemCellModel *> *cellModels;

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
    
    if (iOS10) {
        self.collectionView.prefetchDataSource = self;
    }
}

- (void)setupClearBackground
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)update:(SPItemListMode)mode data:(NSArray *)items
{
    self.items = items ? : self.items;
    self.mode = mode = (mode==kSPItemListModeAuto) ? mode : ([[NSUserDefaults standardUserDefaults] integerForKey:kSPItemListModeKey]);
    
    NSMutableArray *models = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(SPItem *obj, NSUInteger idx, BOOL *stop) {
        SPItemCellModel *model = [SPItemCellModel viewModelWithEntity:obj];
        if (model) {
            model.mode = mode;
            model.lineHidden = idx%4==0;
            [model create];
            [models addObject:model];
        }
    }];
    self.cellModels = models;
    self.mode = mode;
    SPItemLayout *layout = [SPItemLayout layoutWithMode:mode];
    self.flowlayout.itemSize = layout.itemSize;
    self.flowlayout.sectionInset = layout.sectionInset;
    self.flowlayout.minimumInteritemSpacing = layout.interitemSpacing;
    self.flowlayout.minimumLineSpacing = layout.lineSpacing;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.mode==SPItemListModeGrid?kSPItemCellNormal:kSPItemCellLarge;
    SPItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell preload:self.cellModels[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPItemCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (kVelocity <= 3.0f) {
        [cell willDisplay];
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItem *item = self.items[indexPath.row];
    SPItemsDetailViewCtrl *vc = [SPItemsDetailViewCtrl instanceFromStoryboard];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
//    NSMutableArray *itemImages = [NSMutableArray array];
//    for (NSIndexPath *indexPath in indexPaths) {
//        [itemImages addObject:[self.items[indexPath.item] qiniuSmallURL]];
//    }
//    [SPItemImageLoader prefetchItemImages:itemImages];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    float velocity = calculateVelocity(scrollView.contentOffset.y);
//    NSLog(@"%.8f",velocity);
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSArray<SPItemCell *> *cells = [self.collectionView visibleCells];
//    [cells makeObjectsPerformSelector:@selector(willDisplay)];
//}

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
