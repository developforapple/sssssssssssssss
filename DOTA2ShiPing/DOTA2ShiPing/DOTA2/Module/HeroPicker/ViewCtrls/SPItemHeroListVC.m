//
//  SPItemHeroListVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemHeroListVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SPHero.h"
#import "SPHeroCell.h"
#import "SPLogoHeader.h"
#import "SPDataManager.h"

@interface SPItemHeroListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic) NSArray<NSArray *> *heroes;
@end

@implementation SPItemHeroListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self loadData];
}

- (void)initUI
{
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    UIEdgeInsets sectionInset;
    CGFloat itemSpacing = 0.f;
    CGFloat lineSpacing = 0.5f;
    
    width = floorf(Device_Width/4);
    height = ceilf(width * 144.f / 256.f);
    CGFloat margin = (Device_Width - width * 4 ) /2;
    sectionInset = UIEdgeInsetsMake(0.5, margin, 0, margin);
    
    self.flowlayout.itemSize = CGSizeMake(width, height);
    self.flowlayout.sectionInset = sectionInset;
    self.flowlayout.minimumLineSpacing = lineSpacing;
    self.flowlayout.minimumInteritemSpacing = itemSpacing;
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    [SPLogoHeader setLogoHeaderInScrollView:self.collectionView];
}

- (void)reloadData
{
    [self loadData];
    [self.collectionView reloadData];
    [self.collectionView reloadEmptyDataSet];
}

#pragma mark - Data
- (void)loadData
{
    if (self.history) {
        self.heroes = @[[self heroesWithIds:self.history]];
    }else{
        self.heroes = [self heroesWithType:self.type];
    }
}

- (NSArray<SPHero *> *)heroesWithIds:(NSArray *)ids
{
    NSArray *heroes = [SPDataManager shared].heroes;
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *aHeroID in ids) {
        for (SPHero *aHero in heroes) {
            if ([aHero.HeroID isEqualToString:aHeroID]) {
                [tmp addObject:aHero];
                break;
            }
        }
    }
    return tmp;
}

- (NSArray<NSArray<SPHero *> *> *)heroesWithType:(SPHeroType)type
{
    NSArray *heroes = [SPDataManager shared].heroes;

    NSMutableIndexSet *radiantIndex = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *direIndex = [NSMutableIndexSet indexSet];
    
    for (NSInteger idx=0; idx < heroes.count; idx++) {
        SPHero *hero = heroes[idx];
        if (hero.type == type) {
            if (hero.camp == SPHeroCampRadiant) {
                [radiantIndex addIndex:idx];
            }else{
                [direIndex addIndex:idx];
            }
        }
    }
    
    NSArray *radiant = [heroes objectsAtIndexes:radiantIndex];
    NSArray *dire = [heroes objectsAtIndexes:direIndex];
    return @[radiant,dire];
}

#pragma mark - Empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attr = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    return [[NSAttributedString alloc] initWithString:@"没有历史记录" attributes:attr];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (self.history) {
        return self.history.count == 0;
    }
    return NO;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _history?1:2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_heroes[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPHeroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPHeroCell forIndexPath:indexPath];
    [cell configure:_heroes[indexPath.section][indexPath.row]];
    BOOL isFirstItemOfLine = indexPath.row % 4 == 0;
    cell.leftLine.hidden = isFirstItemOfLine;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedHero) {
        self.didSelectedHero(self.heroes[indexPath.section][indexPath.row]);
    }
}

@end
