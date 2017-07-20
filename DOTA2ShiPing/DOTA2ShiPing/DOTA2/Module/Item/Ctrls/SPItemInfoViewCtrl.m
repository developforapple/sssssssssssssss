//
//  SPItemInfoViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemInfoViewCtrl.h"
#import "SPLogoHeader.h"
#import "SPItem.h"
#import "SPItem+Cache.h"
#import "SPDataManager.h"

@interface SPItemInfoViewCtrl ()

@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) SPItemPrefab *prefab;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPItemColor *color;
@property (strong, nonatomic) SPItemQuality *quality;
@property (strong, nonatomic) SPItemSlot *slot;

@property (strong, nonatomic) UIColor *mainColor;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *imagePanel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *titlePanel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) CAGradientLayer *titlePanelBgLayer;

@end

@implementation SPItemInfoViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SPLogoHeader setLogoHeaderInScrollView:self.scrollView];
    
    [self loadData];
    
    [self initUI];
    [self updateUI];
}

- (void)loadData
{
    NSArray<SPHero *> *heroes = [[SPDataManager shared] heroesOfNames:[self.item.heroes componentsSeparatedByString:@"|"]];
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:self.item.item_rarity];
    SPItemPrefab *prefab = [[SPDataManager shared] prefabOfName:self.item.prefab];
    SPItemQuality *quality = [[SPDataManager shared] qualityOfName:self.item.item_quality];
    SPItemSlot *slot = [[SPDataManager shared] slotOfName:self.item.item_slot];
    SPItemColor *color = [[SPDataManager shared] colorOfName:rarity.color];
    
    self.hero = heroes.firstObject;
    self.prefab = prefab;
    self.rarity = rarity;
    self.quality = quality;
    self.slot = slot;
    self.color = color;
}

- (void)initUI
{
    self.imageView.hidden = YES;
}

- (void)updateUI
{
    [self updateImagePanel];
    [self updateTitlePanel];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.titlePanelBgLayer.frame = self.titlePanel.bounds;
}

#pragma mark - Update

- (void)updateImagePanel
{
    ygweakify(self);
    [self.imageView sd_setImageWithURL:[self.item qiniuLargeURL] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageHighPriority  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        ygstrongify(self);
        [self.imageView setHidden:NO animated:YES];
    }];
}

- (void)updateTitlePanel
{
    NSString *titleToken = self.item.item_name;
    self.titleLabel.text = SPLOCAL(titleToken, self.item.name);
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.startPoint = CGPointMake(0, .5f);
    gLayer.endPoint = CGPointMake(1, .5f);
    gLayer.locations = @[@0,@1];
    gLayer.colors = @[(id)[self.color.color colorWithAlphaComponent:.5f].CGColor,
                      (id)[self.color.color colorWithAlphaComponent:.1f].CGColor];
    self.titlePanelBgLayer = gLayer;
    [self.titlePanel.layer insertSublayer:gLayer atIndex:0];
}

@end
