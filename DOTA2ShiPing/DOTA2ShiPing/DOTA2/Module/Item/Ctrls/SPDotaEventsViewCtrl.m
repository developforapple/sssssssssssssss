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
    [self setupLayout:Screen_Size];
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)setupLayout:(CGSize)size
{
    int itemPerLine = IS_iPad ? (IS_Landscape ? 4 : 3) : 2;
    CGFloat width = (size.width - 0.5 * (itemPerLine - 1)) / itemPerLine;
    CGFloat height = width;
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.minimumLineSpacing = 1.f;
    self.flowlayout.minimumInteritemSpacing = 0.f;
}

- (void)loadEvents
{
    self.events = [SPDataManager shared].events;
}

- (void)transitionLayoutToSize:(CGSize)size
{
    [self setupLayout:size];
    [self.collectionView setCollectionViewLayout:self.flowlayout animated:NO];
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
    if (![SPDataManager isDataValid]) {
        [UIAlertController alert:@"数据不完整" message:@"请关闭应用后重试"];
        return;
    }
    SPDotaEvent *event = self.events[indexPath.item];
    SPItemQuery *query = [SPItemQuery queryWithEvent:event];
    query.queryTitle = event.name_loc;
    [self showItemList:query];
    SPBP(Event_Dota_Event, event.event_id);
}

#pragma mark - Segue
- (void)showItemList:(SPItemQuery *)query
{
    SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
    vc.query = query;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
