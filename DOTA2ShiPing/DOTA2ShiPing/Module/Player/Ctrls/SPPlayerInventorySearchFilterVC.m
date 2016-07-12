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
@property (strong, nonatomic) SPInventoryFilterCondition *condition;
@end

@implementation SPPlayerInventorySearchFilterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

#pragma mark 
- (void)removeConditionType:(SPConditionType)type
{
    
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
