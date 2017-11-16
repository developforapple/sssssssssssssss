//
//  SPItemViewCtrl.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemViewCtrl.h"
#import "SPItem.h"
#import "SPItemSharedData.h"
#import "SPGamepediaAPI.h"
#import "SPGamepediaImage.h"
#import "SPItemImageLoader.h"
#import "MXParallaxHeader.h"
#import "SDCycleScrollView.h"
#import "SPItemTitleView.h"
#import "SPItemSaleView.h"
#import "SPItemDescPanel.h"
#import "SPItemMoreItemsView.h"
#import "SPItemBannerView.h"
#import "SPItemPlayableView.h"
#import "SPItemLoadingView.h"
#import "SPConfigManager.h"

@import ReactiveObjC;

static NSString *const kLoadingTappedTipFlag = @"item_loading_tip_flag";

@interface SPItemViewCtrl () <MXParallaxHeaderDelegate>

@property (strong, nonatomic) SPItemSharedData *itemData;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet SPItemBannerView *bannerPanel;
@property (weak, nonatomic) IBOutlet SPItemTitleView *titlePanel;
@property (weak, nonatomic) IBOutlet SPItemSaleView *salePanel;
@property (weak, nonatomic) IBOutlet SPItemLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet SPItemDescPanel *descPanel;
@property (weak, nonatomic) IBOutlet SPItemPlayableView *playablePanel;
@property (weak, nonatomic) IBOutlet SPItemMoreItemsView *moreItemsPanel;

@end

@implementation SPItemViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self loadData];
    [self updateUI];
}

- (void)initUI
{
    self.scrollView.automaticallyAdjustsScrollViewInsets = self.automaticallyAdjustsScrollViewInsets;
    
    self.scrollView.parallaxHeader.delegate = self;
    self.scrollView.parallaxHeader.view = self.bannerPanel;
    self.scrollView.parallaxHeader.height = 2.0 / 3.0 * Device_Width;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20.0;
}

- (void)loadData
{
    self.itemData = [[SPItemSharedData alloc] initWithItem:self.item];
}

- (void)updateUI
{
    self.bannerPanel.itemData = self.itemData;
    self.titlePanel.itemData = self.itemData;
    self.salePanel.itemData = self.itemData;
    self.loadingView.itemData = self.itemData;
    self.playablePanel.itemData = self.itemData;
    self.moreItemsPanel.itemData = self.itemData;
    self.descPanel.itemData = self.itemData;
}

- (void)parallaxHeaderDidScroll:(MXParallaxHeader *)parallaxHeader
{
    [self.bannerPanel setScrollProgress:parallaxHeader.progress];
}

@end
