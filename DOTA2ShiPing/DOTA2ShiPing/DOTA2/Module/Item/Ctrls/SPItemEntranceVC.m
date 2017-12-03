//
//  SPItemEntranceVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemEntranceVC.h"
#import "SPItemEntranceCell.h"
#import "SPItemEntranceConfig.h"
#import "SPItemHeroPickerVC.h"
#import "YYModel.h"
#import "SPLogoHeader.h"
#import "SPDataManager.h"
#import "SPItemListVC.h"
#import "SPItemOffPriceVC.h"
#import "SPDotaEventsViewCtrl.h"
#import "SPDota2API.h"
#import "SPWebHelper.h"

#define kSPItemOffPriceSegueID @"SPItemOffPriceSegueID"

@interface SPItemEntranceVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@property (strong, nonatomic) SPItemEntranceConfig *config;

@end

@implementation SPItemEntranceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadConfigure];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)initUI
{
    CGFloat width = Device_Width/2-0.5f;
    CGFloat height = width;
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.minimumLineSpacing = 1.f;
    self.flowlayout.minimumInteritemSpacing = 0.f;

    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)loadConfigure
{
    self.config = [SPItemEntranceConfig new];
    ygweakify(self);
    self.config.unitDidUpdated = ^(SPItemEntranceUnit *unit) {
        ygstrongify(self);
        [self didUpdateUnit:unit];
    };
    [self.config beginUpdateAuto];
}

- (void)didUpdateUnit:(SPItemEntranceUnit *)unit
{
    NSInteger index = [self.config.units indexOfObject:unit];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.config.units.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemEntranceCell  forIndexPath:indexPath];
    [cell configure:self.config.units[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemEntranceUnit *unit = self.config.units[indexPath.item];
    SPItemEntranceType type = unit.type;
    
    switch (type) {
        case SPItemEntranceTypeOffPrice:{
            NSURL *URL = [NSURL URLWithString:unit.href];
            if (!URL) {
                URL = [NSURL URLWithString:[@"http://dota2.com/store" stringByAppendingFormat:@"/?random=%d",arc4random_uniform(10000)]];
            }
            [SPWebHelper openURL:URL from:self];
        }   break;
        case SPItemEntranceTypeHeroItem:{
            ygweakify(self);
            [SPItemHeroPickerVC bePushingIn:self.navigationController selectedCallback:^BOOL(SPHero *hero) {
                ygstrongify(self);
                SPItemQuery *query = [SPItemQuery queryWithHero:hero];
                [self showItemList:query];
                return NO;
            }];
        }   break;
        case SPItemEntranceTypeEvent:{
            SPDotaEventsViewCtrl *vc = [SPDotaEventsViewCtrl instanceFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }   break;
        case SPItemEntranceTypeCourier:
        case SPItemEntranceTypeWorld:
        case SPItemEntranceTypeHud:
        case SPItemEntranceTypeAudio:
        case SPItemEntranceTypeTreasureBundle:
        case SPItemEntranceTypeLeague:
        case SPItemEntranceTypeOther:{
            NSArray *prefabs = [[SPDataManager shared] prefabsOfEntranceType:type];
            SPItemQuery *query = [SPItemQuery queryWithPerfabs:prefabs];
            query.queryTitle = unit.title;
            [self showItemList:query];
        }   break;
        case SPItemEntranceTypeOnSale:{
            NSString *url = [@"http://dota2.com/store" stringByAppendingFormat:@"/?random=%d",arc4random_uniform(10000)];
            [SPWebHelper openURL:[NSURL URLWithString:url] from:self];
        }   break;
        case SPItemEntranceTypeMarket:{
            NSString *url = @"http://steamcommunity.com/market/search?appid=570";
            [SPWebHelper openURL:[NSURL URLWithString:url] from:self];
        }   break;
    }
}

#pragma mark - Segue
- (void)showItemList:(SPItemQuery *)query
{
    SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
    vc.query = query;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
