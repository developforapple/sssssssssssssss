//
//  SPFilterViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFilterViewCtrl.h"
#import "SPLeftAlignmentLayout.h"
#import "SPBaseFilter.h"

#import "SPFilterCell.h"
#import "SPFilterHeader.h"
#import "SPFilterFooter.h"

#import "SPFilterUnit.h"

@import ReactiveObjC;

@interface SPFilterViewCtrl () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet SPLeftAlignmentLayout *layout;

@end

@implementation SPFilterViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filter.filterViewCtrl = self;
    
    [self initUI];
    [self initSignal];
}

- (void)initUI
{
    [self leftNavButtonImg:@"icon_navi_cancel"];
    [self rightNavSystemItem:UIBarButtonSystemItemDone];
    
    self.layout.maximumInteritemSpacing = 8;
    if (iOS10) {
        self.layout.estimatedItemSize = self.layout.itemSize;//UICollectionViewFlowLayoutAutomaticSize;
    }else{
        self.layout.estimatedItemSize = self.layout.itemSize;
    }
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)initSignal
{
    
}

- (void)doLeftNaviBarItemAction
{
    [super doLeftNaviBarItemAction];
}

- (void)doRightNaviBarItemAction
{
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSMutableArray *list = [NSMutableArray array];

    NSArray<SPFilterUnit *> *inputUnits = [self.filter unitsOfKind:SPFilterKindInput];
    NSIndexSet *validInputUnitIndexes = [inputUnits indexesOfObjectsPassingTest:^BOOL(SPFilterUnit *obj, NSUInteger idx, BOOL *stop) {
        return [(NSString *)obj.object length] > 0;
    }];
    [list addObjectsFromArray:[inputUnits objectsAtIndexes:validInputUnitIndexes]];
    
    for (NSIndexPath *aIndexPath in indexPaths) {
        SPFilterUnit *unit = self.filter.groups[aIndexPath.section].units[aIndexPath.item];
        [list addObject:unit];
    }
    
    if ([self.filter.delegate respondsToSelector:@selector(filter:didCompleted:)]) {
        [self.filter.delegate filter:self.filter didCompleted:list];
    }
    
    [self doLeftNaviBarItemAction];
}

- (SPFilterGroup *)groupOfUnit:(SPFilterUnit *)unit
{
    for (SPFilterGroup *group in self.filter.groups) {
        if ([group.units containsObject:unit]) {
            return group;
        }
    }
    return nil;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.filter.groups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filter.groups[section].units.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterUnit *unit = self.filter.groups[indexPath.section].units[indexPath.item];
    
    SPFilterCell *cell;
    
    switch (unit.kind) {
        case SPFilterKindUnit:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPFilterCell forIndexPath:indexPath];
        }   break;
        case SPFilterKindInput:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPFilterInputCell forIndexPath:indexPath];
            
            ygweakify(self);
            cell.inputContentDidChanged = ^(SPFilterUnit *unit) {
                ygstrongify(self);
                [self.filter didChangedInputText:unit.object toUnit:unit atGroup:[self groupOfUnit:unit]];
            };
            
        }   break;
    }
    
    [cell configure:unit];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SPFilterGroup *group = self.filter.groups[indexPath.section];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        SPFilterHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSPFilterHeader forIndexPath:indexPath];
        
        [header configure:group];
        
        return header;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        SPFilterFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSPFilterFooter forIndexPath:indexPath];
        
        [footer configure:group];
        
        return footer;
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    SPFilterGroup *group = self.filter.groups[section];
    if (group.headerTitle.length > 0) {
        return self.layout.headerReferenceSize;
    }
    return CGSizeMake(1, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    SPFilterGroup *group = self.filter.groups[section];
    if (group.footerTitle.length > 0) {
        return self.layout.footerReferenceSize;
    }
    return CGSizeMake(1, 1);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterGroup *group = self.filter.groups[indexPath.section];
    SPFilterUnit *unit = group.units[indexPath.item];
    
    BOOL should = YES;
    switch (unit.kind) {
        case SPFilterKindUnit:  should = YES;   break;
        case SPFilterKindInput: should = NO;    break;
    }
    return should;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterGroup *group = self.filter.groups[indexPath.section];
    SPFilterUnit *unit = group.units[indexPath.item];
    
    BOOL should = YES;
    switch (unit.kind) {
        case SPFilterKindUnit:  should = YES;   break;
        case SPFilterKindInput: should = NO;    break;
    }
    
    if (should) {
        if (!self.filter.config.allowsMultipleSelection) {
            NSArray *preIndexPaths = [collectionView indexPathsForSelectedItems];
            for (NSIndexPath *aIndexPath in preIndexPaths) {
                [collectionView deselectItemAtIndexPath:aIndexPath animated:YES];
            }
        }else if (!self.filter.config.allowsMultipleSelectionInSection){
            NSArray *preIndexPaths = [collectionView indexPathsForSelectedItems];
            for (NSIndexPath *aIndexPath in preIndexPaths) {
                if (aIndexPath.section == indexPath.section) {
                    [collectionView deselectItemAtIndexPath:aIndexPath animated:YES];
                }
            }
        }
    }
    return should;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterGroup *group = self.filter.groups[indexPath.section];
    SPFilterUnit *unit = group.units[indexPath.item];
    [self.filter didSelectedUnit:unit atGroup:group];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterGroup *group = self.filter.groups[indexPath.section];
    SPFilterUnit *unit = group.units[indexPath.item];
    [self.filter didDeselectedUnit:unit atGroup:group];
}


@end
