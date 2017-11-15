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
#import "SPLeftAlignmentLayout.h"
@import ReactiveObjC;
@import AVKit;

@interface SPItemPlayableView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemsView;
@property (weak, nonatomic) IBOutlet SPLeftAlignmentLayout *layout;
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
    self.layout.estimatedItemSize = self.layout.itemSize;
    self.layout.maximumInteritemSpacing = 8.0;
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
        self.itemsViewHeightConstraint.constant = h;
        [self layoutIfNeeded];
    }];
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
    [[self viewController] presentViewController:vc animated:YES completion:nil];
}

@end
