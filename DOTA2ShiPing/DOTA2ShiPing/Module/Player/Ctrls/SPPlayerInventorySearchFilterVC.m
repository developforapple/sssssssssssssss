//
//  SPPlayerInventorySearchFilterVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/12.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventorySearchFilterVC.h"
#import "SPMacro.h"
#import "SPInventoryConditionCell.h"

@interface SPPlayerInventorySearchFilterVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (weak, nonatomic) IBOutlet UILabel *filterResultCountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tradeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *marketSegment;
@property (strong, nonatomic) SPInventoryFilterCondition *condition;
@end

@implementation SPPlayerInventorySearchFilterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    self.condition = [[SPInventoryFilterCondition alloc] init];
    
    UIEdgeInsets insets = self.flowlayout.sectionInset;
    if (IS_5_5_INCH_SCREEN) {
        insets.left = 56.f;
        insets.right = 56.f;
        self.flowlayout.minimumInteritemSpacing = 60.f;
    }else if (IS_4_7_INCH_SCREEN){
        insets.left = 47.f;
        insets.right = 47.f;
        self.flowlayout.minimumInteritemSpacing = 50.f;
    }else{
        insets.left = 30.f;
        insets.right = 30.f;
        self.flowlayout.minimumInteritemSpacing = 40.f;
    }
    self.flowlayout.sectionInset = insets;
    
    self.tradeSegment.tintColor = AppBarColor;
    self.marketSegment.tintColor = AppBarColor;
    
    if (self.filter.condition) {
        self.condition = self.filter.condition;
    }else{
        self.condition = [[SPInventoryFilterCondition alloc] init];
    }
    self.tradeSegment.selectedSegmentIndex = self.condition.tradeable;
    self.marketSegment.selectedSegmentIndex = self.condition.markedable;
}

#pragma mark - Update
- (void)update
{
    NSUInteger count = [self.filter updateWithCondition:self.condition];
    [self.collectionView reloadData];
    self.filterResultCountLabel.text = [NSString stringWithFormat:@"匹配到 %lu 个结果",(unsigned long)count];
}

#pragma mark 
- (void)removeConditionType:(SPConditionType)type
{
    [self.view.window endEditing:YES];
}

#pragma mark - Action
- (IBAction)segmentValueChanged:(UISegmentedControl *)segment
{
    [self.view.window endEditing:YES];
    if (segment == self.tradeSegment) {
        self.condition.tradeable = segment.selectedSegmentIndex;
    }else{
        self.condition.markedable = segment.selectedSegmentIndex;
    }
    [self update];
}

- (IBAction)startFilter:(UIButton *)sender
{
    [self.view.window endEditing:YES];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPInventoryConditionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPInventoryConditionCell forIndexPath:indexPath];
    cell.type = indexPath.item;
    [cell configureWithCondition:self.condition];
    [cell setWillRemoveCondition:^(SPConditionType type) {
        [self removeConditionType:type];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view.window endEditing:YES];
    SPConditionType type = indexPath.item;
    switch (type) {
        case SPConditionTypeHero: {
            
            break;
        }
        case SPConditionTypeQuality: {
            
            break;
        }
        case SPConditionTypeRarity: {
            
            break;
        }
    }
}

@end
