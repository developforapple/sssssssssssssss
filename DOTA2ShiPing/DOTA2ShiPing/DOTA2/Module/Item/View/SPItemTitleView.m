//
//  SPItemTitleView.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemTitleView.h"
#import "SPItemSharedData.h"
#import "SPLeftAlignmentLayout.h"
#import "SPItemImageLoader.h"
#import "SPDataManager.h"
#import "Chameleon.h"

@interface SPItemTitleView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagView;
@property (weak, nonatomic) IBOutlet SPLeftAlignmentLayout *tagViewLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;

@property (strong, nonatomic) NSArray<SPItemTag *> * tags;

@end

@implementation SPItemTitleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tagViewLayout.estimatedItemSize = self.tagViewLayout.itemSize;
    self.tagViewLayout.maximumInteritemSpacing = 10.0;
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
}

- (void)update
{
    if (self.itemData.playerItem) {
        self.titleLabel.text = self.itemData.playerItem.market_name;
    }else{
        self.titleLabel.text = self.itemData.item.nameWithQualtity;
    }
    self.subtitleLabel.text = self.itemData.item.enNameWithQuality;
    
    SPHero *hero = self.itemData.hero;
    if (hero) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[hero vertImageURL]] placeholderImage:placeholderImage(self.imageView.bounds.size) options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground];
    }else{
        self.imageView.collapsed = YES;
    }
    
    UIColor *color = FlatGrayDark;//self.itemData.color;
    
    NSMutableArray *tags = [NSMutableArray array];
    
    if (self.itemData.playerItem) {
        NSString *qualityName = self.itemData.playerItem.qualityTag.name;
        [tags addObject:[SPItemTag tag:qualityName color:color]];
    }
    
    // hero tag
    if (hero) {
        [tags addObject:[SPItemTag tag:hero.name_loc color:color]];
    }
    
    // rarity tag
    if (self.itemData.rarity) {
//        SPItemColor *color = [[SPDataManager shared] colorOfName:self.itemData.rarity.color];
        [tags addObject:[SPItemTag tag:self.itemData.rarity.name_loc color:color]];
    }
    
    // type tag
    NSString *type = SPLOCALNONIL(self.itemData.item.item_type_name);
    if (type.length) {
        [tags addObject:[SPItemTag tag:type color:color]];
    }
    
    // slot tag
    if (self.itemData.slot) {
        [tags addObject:[SPItemTag tag:self.itemData.slot.name_loc color:color]];
    }
    
    //item set tag
    if (self.itemData.itemSet) {
        [tags addObject:[SPItemTag tag:self.itemData.itemSet.name_loc color:color]];
    }
    
    //event tag
    if (self.itemData.event) {
        [tags addObject:[SPItemTag tag:self.itemData.event.name_loc color:color]];
    }
    
    // 可交易 tag
    if (self.itemData.playerItem) {
        BOOL tradable = self.itemData.playerItem.tradable.boolValue;
        [tags addObject:[SPItemTag tag:tradable ? @"可交易" : @"不可交易" color:color]];
    }
    
    // 可出售 tag
    if (self.itemData.playerItem) {
        BOOL marketable = self.itemData.playerItem.marketable.boolValue;
        [tags addObject:[SPItemTag tag:marketable ? @"可出售" : @"不可出售"  color:color]];
    }
    
    self.tags = tags;
    [self.tagView reloadData];
    
    ygweakify(self);
    [self.tagView performBatchUpdates:^{
        ygstrongify(self);
        [self.tagView reloadData];
    } completion:^(BOOL finished) {
        ygstrongify(self);
        self.tagViewHeightConstraint.constant = self.tagView.contentSize.height;
        [self layoutIfNeeded];
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemTagCell forIndexPath:indexPath];
    cell.tagInfo = self.tags[indexPath.item];
    return cell;
}

@end

@implementation SPItemTag

+ (instancetype)tag:(NSString *)tag color:(UIColor *)color
{
    SPItemTag *instance = [SPItemTag new];
    instance.tag = tag;
    instance.color = color;
    return instance;
}

@end

NSString *const kSPItemTagCell = @"SPItemTagCell";

@implementation SPItemTagCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 4.f;
    self.contentView.layer.borderWidth = 0.5f;
}

- (void)setTagInfo:(SPItemTag *)tagInfo
{
    _tagInfo = tagInfo;
    self.tagLabel.text = tagInfo.tag;
    self.tagLabel.textColor = [UIColor whiteColor];
//    self.contentView.backgroundColor = [tagInfo.color colorWithAlphaComponent:0.8];
    self.tagLabel.textColor = tagInfo.color ? : FlatGrayDark;
    self.contentView.layer.borderColor = self.tagLabel.textColor.CGColor;
}

@end
