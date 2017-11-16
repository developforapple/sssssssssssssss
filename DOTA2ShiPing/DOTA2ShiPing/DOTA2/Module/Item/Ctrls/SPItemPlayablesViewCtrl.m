//
//  SPItemPlayablesViewCtrl.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPlayablesViewCtrl.h"
#import "SPItemPlayableCell.h"
@import AVKit;

@interface SPItemPlayablesViewCtrl ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@end

@implementation SPItemPlayablesViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.playables.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemPlayableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemPlayableCell forIndexPath:indexPath];
//    [cell setMaxWidth:CGRectGetWidth(collectionView.bounds) - collectionView.contentInset.left - collectionView.contentInset.right - self.layout.sectionInset.left - self.layout.sectionInset.right];
    cell.nameLabel.text = self.playables[indexPath.item].title;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftMargin = collectionView.contentInset.left + self.layout.sectionInset.left;
    CGFloat rightMargin = collectionView.contentInset.right + self.layout.sectionInset.right;
    CGFloat width = (CGRectGetWidth(collectionView.bounds) - leftMargin - rightMargin - self.layout.minimumInteritemSpacing) / 2;
    CGFloat height = 44.f;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.playables[indexPath.item].resource]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
