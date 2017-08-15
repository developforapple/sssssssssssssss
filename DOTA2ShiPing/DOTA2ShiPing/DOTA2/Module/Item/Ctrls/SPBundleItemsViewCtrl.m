//
//  SPBundleItemsViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/4.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBundleItemsViewCtrl.h"
#import "SPItem.h"
#import "SPItemCell.h"
#import "SPItemsDetailViewCtrl.h"
#import "SPItemFilter.h"
#import "SPDataManager.h"
#import "SPItemCellModel.h"

@interface SPBundleItemsViewCtrl () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) SPItemListMode mode;
@property (strong, nonatomic) SPItemFilter *filter;
@property (strong, nonatomic) SPItemSets *set;

@property (strong, nonatomic) NSArray<SPItem *> *items;
@property (strong, nonatomic) NSArray<SPItemCellModel *> *cellModels;

@end

@implementation SPBundleItemsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initUI
{
    self.mode = SPItemListModeGrid;
    
    [self.view layoutIfNeeded];
    CGFloat containerWidth = CGRectGetWidth(self.collectionView.frame);
    
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    UIEdgeInsets sectionInset;
    CGFloat itemSpacing = 0.f;
    CGFloat lineSpacing = 0.f;
    
    width = floorf(containerWidth/4);
    height = ceilf(width/1.5f + 20.f);
    CGFloat margin = (containerWidth - width * 4 );
    sectionInset = UIEdgeInsetsMake(0, 0, 0, margin);
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.sectionInset = sectionInset;
    self.flowlayout.minimumLineSpacing = lineSpacing;
    self.flowlayout.minimumInteritemSpacing = itemSpacing;
}

- (void)setItem:(SPItem *)item
{
    _item = item;
    [self initUI];
    [self loadData];
}

- (void)loadData
{
    if (!self.item) return;
    
    NSString *bundleItems = self.item.bundleItems;
    NSString *bundles = self.item.bundles;
    NSString *lootList = self.item.lootList;
    
    if (bundleItems.length) {
        // 饰品是一个包
        NSArray *itemNames = [bundleItems componentsSeparatedByString:@"||"];
        self.filter = [SPItemFilter filterWithItemNames:itemNames];
        [self loadBundleItems];
        
    }else if (bundles.length){
        // 饰品属于一个包
        NSString *bundleName = [bundles componentsSeparatedByString:@"||"].firstObject;

        SPDBWITHOPEN
        
        NSError *error;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sets WHERE store_bundle = ?"];
        FMResultSet *result = [db executeQuery:sql values:@[bundleName] error:&error];
        
        if ([result nextWithError:&error]) {
            NSDictionary *dict = [result resultDictionary];
            SPItemSets *set = [SPItemSets yy_modelWithJSON:dict];
            
            SPDBCLOSE
            
            NSArray *itemNames = set.items;
            self.filter = [SPItemFilter filterWithItemNames:itemNames];
            [self loadBundleItems];
        }else{
            SPDBCLOSE
        }
        
    }else if (lootList.length){
        //包含一个掉落列表
        NSArray *itemNames = [[SPDataManager shared] itemsInLootlist:lootList];
        self.filter = [SPItemFilter filterWithItemNames:itemNames];
        [self loadBundleItems];
        
    }else{
        //不包含包内容
        [self callback];
    }
}

- (void)loadBundleItems
{
    RunOnGlobalQueue(^{
        [self.filter updateItems];
        
        RunOnMainQueue(^{
            self.items = self.filter.items;
            [self.collectionView reloadData];
            
            ygweakify(self);
            [self.collectionView performBatchUpdates:^{
                ygstrongify(self);
                [self.collectionView reloadData];
            } completion:^(BOOL finished) {
                ygstrongify(self);
                [self callback];
            }];
        });
    });
}

- (void)callback
{
    CGFloat height = self.items.count == 0 ? 0.f : self.collectionView.contentSize.height;
    if (self.heightDidChanged) {
        self.heightDidChanged(height);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.mode==SPItemListModeGrid?kSPItemCellNormal:kSPItemCellLarge;
    SPItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    [cell preload:^(SPItemCellConfig *c) {
//        c.mode = self.mode;
//        c.item = self.items[indexPath.row];
//        c.lineHidden = YES;
//    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPItemCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell willDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItem *item = self.items[indexPath.row];
    SPItemsDetailViewCtrl *vc = [SPItemsDetailViewCtrl instanceFromStoryboard];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
