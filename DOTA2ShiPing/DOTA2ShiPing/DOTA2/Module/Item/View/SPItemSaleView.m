//
//  SPItemSaleView.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSaleView.h"
#import "SPItemSharedData.h"

@interface SPItemSaleView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UICollectionView *platformView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *platformLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformHeightConstraint;

@property (strong, nonatomic) NSArray<SPItemPlatform *> *salePlatforms;

@end

@implementation SPItemSaleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.salePlatforms = @[[SPItemPlatform named:@"Dota2商城" logoNamed:@"logo_steam"],
                           [SPItemPlatform named:@"Steam市场" logoNamed:@"logo_steam"],
                           [SPItemPlatform named:@"淘宝网" logoNamed:@"logo_taobao"]];
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
}

- (void)update
{
    ygweakify(self);
    [self.platformView performBatchUpdates:^{
        ygstrongify(self);
        [self.platformView reloadData];
    } completion:^(BOOL finished) {
        ygstrongify(self);
        CGSize size = self.platformView.contentSize;
        self.platformWidthConstraint.constant = size.width;
        self.platformHeightConstraint.constant = size.height;
        [self layoutIfNeeded];
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.salePlatforms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemPlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemPlatformCell forIndexPath:indexPath];
    cell.platform = self.salePlatforms[indexPath.item];
    return cell;
}

@end

@implementation SPItemPlatform

+ (instancetype)named:(NSString *)name logoNamed:(NSString *)logoName
{
    SPItemPlatform *instance = [SPItemPlatform new];
    instance.name = name;
    instance.logo = [UIImage imageNamed:logoName];
    return instance;
}

@end

NSString *const kSPItemPlatformCell = @"SPItemPlatformCell";

@implementation SPItemPlatformCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setPlatform:(SPItemPlatform *)platform
{
    _platform = platform;
    
    self.nameLabel.text = platform.name;
    self.logoImageView.image = platform.logo;
}

@end
