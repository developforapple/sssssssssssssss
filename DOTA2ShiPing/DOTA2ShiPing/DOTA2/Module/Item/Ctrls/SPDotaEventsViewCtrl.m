//
//  SPDotaEventsViewCtrl.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPDotaEventsViewCtrl.h"
#import "SPLogoHeader.h"
#import "SPDotaEvent.h"
#import "SPDataManager.h"
#import "SPItemEntranceCell.h"
#import "SPItemQuery.h"
#import "SPItemListVC.h"

@interface SPDotaEventsViewCtrl ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic) NSArray<SPDotaEvent *> *events;
@end

@implementation SPDotaEventsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self loadEvents];
}

- (void)initUI
{
    CGFloat width = Device_Width/2-0.5f;
    CGFloat height = width;// width * 340 / 512.f;
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.minimumLineSpacing = 1.f;
    self.flowlayout.minimumInteritemSpacing = 0.f;
    
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)loadEvents
{
    self.events = [SPDataManager shared].events;
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemEntranceCell  forIndexPath:indexPath];
    [cell configureWithEvent:self.events[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPDotaEvent *event = self.events[indexPath.item];
    SPItemQuery *query = [SPItemQuery queryWithEvent:event];
    query.queryTitle = event.name_loc;
    [self showItemList:query];
}

#pragma mark - Segue
- (void)showItemList:(SPItemQuery *)query
{
    SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
    vc.query = query;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
