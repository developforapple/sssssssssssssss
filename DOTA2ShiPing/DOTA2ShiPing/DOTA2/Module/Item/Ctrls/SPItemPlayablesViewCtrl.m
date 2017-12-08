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
    
    [self setupLayout:Screen_Size];
}

- (void)setupLayout:(CGSize)size
{
    NSInteger itemPerLine = IS_iPad ? (IS_Landscape ? 4 : 3) : 2;
    CGFloat leftMargin = self.collectionView.contentInset.left + self.layout.sectionInset.left;
    CGFloat rightMargin = self.collectionView.contentInset.right + self.layout.sectionInset.right;
    CGFloat width = (size.width - leftMargin - rightMargin - self.layout.minimumInteritemSpacing * (itemPerLine-1)) / itemPerLine;
    CGFloat height = 44.f;
    self.layout.itemSize = CGSizeMake(floorf(width), height);
}

- (void)transitionLayoutToSize:(CGSize)size
{
    [self setupLayout:size];
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.playables.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemPlayableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemPlayableCell forIndexPath:indexPath];
    cell.nameLabel.text = self.playables[indexPath.item].title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.playables[indexPath.item].resource]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
