//
//  SPWorkshopResourcesVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/19.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopResourcesVC.h"
#import "SPWorkshopModel.h"

#import "DDProgressHUD.h"
#import "SPLogoHeader.h"
#import "SPWorkshopResourceCell.h"
#import "SPWorkshop.h"
#import "SPWebHelper.h"
#import "IDMPhotoBrowser.h"
#import "SPDiskCacheControl.h"

@interface SPWorkshopResourcesVC () <UICollectionViewDelegateFlowLayout>
@end

@implementation SPWorkshopResourcesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];

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
        
        SPWorkshopResourceCell *cell = (SPWorkshopResourceCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSArray *IDMPhotos = [self.unit imageResourceIDMPhotos];
        for (IDMPhoto *p in IDMPhotos) {
//            p.manager = [SPDiskCacheControl workshopImageManager];
        }
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:IDMPhotos animatedFromView:cell.imageView];
//        browser.currentPageIndex = [self.unit indexInImageResourcesOfResource:resource];
        
        [self presentViewController:browser animated:YES completion:nil];
    }
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPWorkshopResourceCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateCellTransform:cell];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = Device_Width;
    CGFloat h = w * 0.618f;
    return CGSizeMake(w, ceilf(h));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (SPWorkshopResourceCell *cell in [self.collectionView visibleCells]) {
        [self updateCellTransform:cell];
    }
}

- (void)updateCellTransform:(SPWorkshopResourceCell *)cell
{
    CGFloat height = CGRectGetHeight(self.collectionView.frame);
    CGFloat viewHeight = height + self.collectionView.contentInset.top;
    CGFloat centerY = CGRectGetMidY(cell.frame);
    CGFloat y = centerY - self.collectionView.contentOffset.y;
    CGFloat p = y - viewHeight / 2;
    CGFloat scale = cos(p / viewHeight * 1);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        cell.imageView.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:NULL];
}

@end
