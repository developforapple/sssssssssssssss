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
#import "SPMacro.h"
#import "SPItemListVC.h"

#define kSPItemOffPriceSegueID @"SPItemOffPriceSegueID"
#define kSPItemItemListSegueID @"SPItemItemListSegueID"

@interface SPItemEntranceVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;

@property (strong, nonatomic) NSArray<SPItemEntranceConfig *> *configure;

@end

@implementation SPItemEntranceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadConfigure];
}

- (void)initUI
{
    CGFloat width = DeviceWidth/2-0.5f;
    CGFloat height = width;// width * 340 / 512.f;
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.minimumLineSpacing = 1.f;
    self.flowlayout.minimumInteritemSpacing = 0.f;

    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)loadConfigure
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SPItemEntranceConfigure" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.configure = [NSArray yy_modelArrayWithClass:[SPItemEntranceConfig class] json:json];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.configure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemEntranceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemEntranceCell  forIndexPath:indexPath];
    [cell configure:self.configure[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemEntranceType type = indexPath.row;
    
    switch (type) {
        case SPItemEntranceTypeOffPrice:
            [self performSegueWithIdentifier:kSPItemOffPriceSegueID sender:nil];
            break;
        case SPItemEntranceTypeHeroItem:{
            SPItemHeroPickerVC *vc = [SPItemHeroPickerVC instanceFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }   break;
        case SPItemEntranceTypeCourier:
        case SPItemEntranceTypeWorld:
        case SPItemEntranceTypeHud:
        case SPItemEntranceTypeAudio:
        case SPItemEntranceTypeTreasure:
        case SPItemEntranceTypeOther:{
            NSArray *prefabs = [[SPDataManager shared] prefabsOfEntranceType:type];
            SPItemFilter *filter = [SPItemFilter filterWithPerfabs:prefabs];
            filter.filterTitle = [self.configure[indexPath.item] title];
            [self performSegueWithIdentifier:kSPItemItemListSegueID sender:filter];
        }   break;
        default:
            break;
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPItemItemListSegueID]) {
        UIViewController *vc = [segue destinationViewController];
        SEL sel = @selector(setFilter:);
        if ([vc respondsToSelector:sel]) {
            [vc performSelector:sel withObject:sender];
        }
    }
}

@end
