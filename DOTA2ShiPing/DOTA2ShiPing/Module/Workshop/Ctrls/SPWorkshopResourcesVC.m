//
//  SPWorkshopResourcesVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/19.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopResourcesVC.h"
#import "SPWorkshopModel.h"
#import "SPMacro.h"
#import "DDProgressHUD.h"
#import "SPLogoHeader.h"
#import "SPWorkshopResourceCell.h"
#import "SPWorkshop.h"
#import "SPWebHelper.h"

@interface SPWorkshopResourcesVC () <UICollectionViewDelegateFlowLayout>
@end

@implementation SPWorkshopResourcesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjrefresh:)];
//    self.collectionView.mj_footer = footer;

    if (self.unit.resources.count == 0) {
        DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
        [SPWorkshop fetchResource:self.unit completion:^(BOOL suc, SPWorkshopUnit *unit) {
            [HUD hide:YES];
            self.navigationItem.title = [NSString stringWithFormat:@"视频和图片资源(%lu)",(unsigned long)unit.resources.count];
            [self.collectionView reloadData];
        }];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"视频和图片资源(%lu)",(unsigned long)self.unit.resources.count];
    }
}

- (void)mjrefresh:(MJRefreshComponent *)mj
{
    NSLog(@"loadMore");
    
    [self.collectionView.mj_footer endRefreshing];
}

- (void)dealloc
{
    NSLog(@"%@释放",NSStringFromClass(self.class));
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.unit.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPWorkshopResourceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPWorkshopResourceCell forIndexPath:indexPath];
    [cell configureWithResource:self.unit.resources[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPWorkshopResource *resource = self.unit.resources[indexPath.item];
    if ([resource isVideo]) {
        
        [SPWebHelper openURL:resource.fullURL from:self];
        
    }else{
        
    }
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = DeviceWidth;
    CGFloat h = w * 0.618f;
    return CGSizeMake(w, ceilf(h));
}

@end
