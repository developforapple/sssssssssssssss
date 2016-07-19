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
#import <YYWebImage.h>

@interface SPWorkshopResourcesVC () <UICollectionViewDelegateFlowLayout>

@end

@implementation SPWorkshopResourcesVC

static NSString * const kSPWorkshopResourceCell = @"SPWorkshopResourceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.unit.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPWorkshopResourceCell forIndexPath:indexPath];
    YYAnimatedImageView *imageView = [cell viewWithTag:10086];
    
    SPWorkshopResource *resource = self.unit.resources[indexPath.item];
    NSString *URL = [resource.resource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [imageView yy_setImageWithURL:[NSURL URLWithString:URL] options:kNilOptions];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DeviceWidth, 200.f);
}

@end
