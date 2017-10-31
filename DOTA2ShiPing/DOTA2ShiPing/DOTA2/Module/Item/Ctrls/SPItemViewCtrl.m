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

@interface SPItemViewCtrl ()

@property (strong, nonatomic) SPItemSharedData *itemData;
@property (strong, nonatomic) NSArray<SPGamepediaImage *> *extraImages;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet SDCycleScrollView *imagePanel;
@property (weak, nonatomic) IBOutlet SPItemTitleView *titlePanel;
@property (weak, nonatomic) IBOutlet SPItemSaleView *salePanel;

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
    
    self.scrollView.parallaxHeader.view = self.imagePanel;
    self.scrollView.parallaxHeader.height = 2.0 / 3.0 * Device_Width;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 20.0;
    
    self.imagePanel.autoScrollTimeInterval = 1.5f;
    self.imagePanel.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.imagePanel.showPageControl = YES;
    self.imagePanel.placeholderImage = nil;
    self.imagePanel.autoScroll = YES;
    self.imagePanel.backgroundColor = [UIColor clearColor];
}

- (void)loadData
{
    self.itemData = [[SPItemSharedData alloc] initWithItem:self.item];
    
}

- (void)updateUI
{
    [self updateImagePanel];
    
    self.titlePanel.itemData = self.itemData;
    self.salePanel.itemData = self.itemData;
}

- (void)updateImagePanel
{
    NSMutableArray *extraImageURLs = [NSMutableArray arrayWithObject:[self.itemData.item qiniuLargeURL]];
    for (SPGamepediaImage *aImage in self.extraImages) {
        [extraImageURLs addObject:aImage.fullsizeImageURL];
    }
    self.imagePanel.imageURLStringsGroup = extraImageURLs;
}

@end
