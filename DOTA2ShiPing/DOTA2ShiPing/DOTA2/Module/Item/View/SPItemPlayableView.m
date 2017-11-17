//
//  SPItemPlayableView.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPlayableView.h"
#import "SPItemSharedData.h"
@import ChameleonFramework;
#import "SPItemPlayableCell.h"
#import "SPItemPlayablesViewCtrl.h"
@import ReactiveObjC;
@import AVKit;

static NSInteger kMaxPlayableCount = 6;

@interface SPItemPlayableView () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemsView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zeroHeightConstraint;

@property (strong, nonatomic) NSArray<SPGamepediaPlayable *> *playables;
@end

@implementation SPItemPlayableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI
{
    
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self initUI];
    
    ygweakify(self);
    [[RACObserve(itemData, extraData)
      map:^id (SPGamepediaData *value) {
          return value.playables;
      }]
     subscribeNext:^(id x) {
         ygstrongify(self);
         [self update];
     }];
}

- (void)update
{
    self.playables = self.itemData.extraData.playables;
    if (self.playables.count == 0) {
        self.zeroHeightConstraint.priority = 999;
        [self setNeedsLayout];
        return;
    }
    [UIView animateWithDuration:.1f animations:^{
        self.zeroHeightConstraint.priority = 200;
        [self.itemsView reloadData];
    } completion:^(BOOL finished) {
        CGFloat h = self.itemsView.contentSize.height;
        
        [UIView animateWithDuration:.2f animations:^{
            self.itemsViewHeightConstraint.constant = h;
            [self layoutIfNeeded];
        }];
    }];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(kMaxPlayableCount, self.playables.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemPlayableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemPlayableCell forIndexPath:indexPath];
    if (indexPath.item == kMaxPlayableCount - 1 && self.playables.count > kMaxPlayableCount) {
        cell.nameLabel.text = @"(查看更多音频内容)";
    }else{
        cell.nameLabel.text = self.playables[indexPath.item].title;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat leftMargin = self.itemsView.contentInset.left + self.layout.sectionInset.left;
    CGFloat rightMargin = self.itemsView.contentInset.right + self.layout.sectionInset.right;
    CGFloat width = (CGRectGetWidth(self.itemsView.bounds) - leftMargin - rightMargin - self.layout.minimumInteritemSpacing) / 2;
    CGFloat height = 44.f;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.playables.count > kMaxPlayableCount && indexPath.item == kMaxPlayableCount - 1) {
        SPItemPlayablesViewCtrl *vc = [SPItemPlayablesViewCtrl instanceFromStoryboard];
        vc.playables = self.playables;
        [[[self viewController] navigationController] pushViewController:vc animated:YES];
        return;
    }
    
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.playables[indexPath.item].resource]];
    [[self viewController] presentViewController:vc animated:YES completion:nil];
}

@end
