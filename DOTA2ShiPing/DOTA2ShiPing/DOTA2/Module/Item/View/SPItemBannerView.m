//
//  SPItemBannerView.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemBannerView.h"
#import "SPItemSharedData.h"
#import "SPItemImageLoader.h"
#import "SPItemBannerImageCell.h"
@import ReactiveObjC;
@import IDMPhotoBrowser;

static const NSInteger kInvalidValue = -1;

#pragma mark - SPItemBannerImageInfo
@interface SPItemBannerImageInfo ()

@end

@implementation SPItemBannerImageInfo
- (instancetype)init:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.url = URL;
        self.received = kInvalidValue;
        self.length = kInvalidValue;
        self.playable = [URL.pathExtension caseInsensitiveCompare:@"gif"] == NSOrderedSame ? SPItemBannerPlayableGif : SPItemBannerPlayableNone;;
    }
    return self;
}

- (CGFloat)progress
{
    if (self.received < 0 || self.length <= 0) {
        return kInvalidValue;
    }
    return self.received / (CGFloat)self.length;
}

- (NSString *)lengthDesc
{
    NSInteger imageSize = self.length;
    if (imageSize >= 1024 * 1024) {
        CGFloat mb = imageSize / 1024.f / 1024.f;
        return [NSString stringWithFormat:@"%.1fMB",mb];
    }else if (imageSize >= 1024){
        CGFloat kb = imageSize / 1024.f;
        return [NSString stringWithFormat:@"%.1fKB",kb];
    }else if (imageSize > 0){
        return [NSString stringWithFormat:@"%dByte",imageSize];
    }else{
        return @"";
    }
}

- (BOOL)isPlayable
{
    return self.playable != SPItemBannerPlayableNone;
}
@end

#pragma mark - SPItemBannerInfoUnit
@interface SPItemBannerInfoUnit ()

@end

@implementation SPItemBannerInfoUnit

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)update:(SPItemBannerImageInfo *)info
{
    switch (self.type) {
        case SPItemBannerInfoTypeIndex:{
            self.infoLabel.text = [NSString stringWithFormat:@"%d/%d",info.index+1,info.imageCount];
        }   break;
        case SPItemBannerInfoTypeProgress:{
            self.infoLabel.text = [NSString stringWithFormat:@"%.0f%%",[info progress] * 100];
        }   break;
        case SPItemBannerInfoTypePlayable:{
            switch (info.playable) {
                case SPItemBannerPlayableNone:break;
                case SPItemBannerPlayableGif:{
                    self.infoLabel.text = @"GIF";
                }   break;
                case SPItemBannerPlayableVideo:{
                    self.infoLabel.text = @"视频";
                }   break;
                case SPItemBannerPlayableAudio:{
                    self.infoLabel.text = @"音频";
                }   break;
            }
        }   break;
        case SPItemBannerInfoTypeSize:{
            self.infoLabel.text = [info lengthDesc];
        }   break;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    self.horizontalZero_ = hidden;
    self.collapsed = hidden;
}

@end


#pragma mark - SPItemBannerInfoView
@interface SPItemBannerInfoView ()

@end

@implementation SPItemBannerInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.indexUnit.type = SPItemBannerInfoTypeIndex;
    self.sizeUnit.type = SPItemBannerInfoTypeSize;
    self.playableUnit.type = SPItemBannerInfoTypePlayable;
    self.progressUnit.type = SPItemBannerInfoTypeProgress;
}

- (void)setShouldShow:(BOOL)shouldShow
{
    _shouldShow = shouldShow;
    [self setHidden:!shouldShow animated:YES];
}

- (void)update:(SPItemBannerImageInfo *)info
{
    if (!self.shouldShow) return;
    
    // index
    [self.indexUnit update:info];
    self.indexUnit.hidden = NO;
    
    // size
    if (info.length != kInvalidValue) {
        [self.sizeUnit update:info];
        self.sizeUnit.hidden = NO;
    }else{
        self.sizeUnit.hidden = YES;
    }
    
    // playable
    if ( [info isPlayable]) {
        [self.playableUnit update:info];
        self.playableUnit.hidden = NO;
    }else{
        self.playableUnit.hidden = YES;
    }
    
    // progress
    if (!info.completed && info.received != kInvalidValue && info.length != kInvalidValue) {
        [self.progressUnit update:info];
        self.progressUnit.hidden = NO;
    }else{
        self.progressUnit.hidden = YES;
    }
    
    [self layoutIfNeeded];
}
@end


#pragma mark - SPItemBannerView

@interface SPItemBannerView () <UICollectionViewDelegate,UICollectionViewDataSource,IDMPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray<SPItemBannerImageInfo *> *imageInfoList;
@property (strong, nonatomic) NSMutableArray<NSURL *> *imageURLs;

@property (assign, nonatomic) NSInteger curIndex;
@property (strong, nonatomic) RACDisposable *disposable;

@property (assign, nonatomic) BOOL hasExtraImages;
@property (copy, nonatomic) NSURL *curURL;

@property (assign, nonatomic) NSInteger photoBrowserIndex;

@end

@implementation SPItemBannerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.collectionView.insetsLayoutMarginsFromSafeArea = NO;
    }
    [self layoutIfNeeded];
    self.layout.itemSize = self.bounds.size;
    [self reset];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat previousHeight = CGRectGetHeight(_collectionView.bounds);
    if (height < previousHeight) {
        _layout.itemSize = self.bounds.size;
        _collectionView.frame = self.bounds;
    }else{
        _collectionView.frame = self.bounds;
        _layout.itemSize = self.bounds.size;
    }
    [_collectionView setCollectionViewLayout:_layout animated:YES];
}

- (void)dealloc
{
    if (!_disposable.isDisposed) {
        [_disposable dispose];
    }
    _disposable = nil;
    
    [_imageInfoList removeAllObjects];
}

- (void)updateCurImageIndex:(NSInteger)index
{
    self.curIndex = index;
    SPItemBannerImageInfo *info = self.imageInfoList[index];
    [self watchImageInfo:info];
}

- (void)watchImageInfo:(SPItemBannerImageInfo *)info
{
    if (self.disposable) {
        [self.disposable dispose];
        self.disposable = nil;
    }
    if (!info) return;
    
    RACSignal *signal = [RACSignal combineLatest:@[RACObserve(info, received),
                                                   RACObserve(info, length),
                                                   RACObserve(info, completed),
                                                   RACObserve(info, error)]];
    ygweakify(self);
    self.disposable =
    [[signal
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         ygstrongify(self);
         [self updateImageInfoView];
     }];
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
}

- (void)setScrollProgress:(float)progress
{
    float alpha = (progress - 0.1) / (1 - 0.5 - 0.1);
    alpha = Confine(alpha, 1, 0);
    self.infoView.alpha = alpha;
}

- (void)update
{
    ygweakify(self);
    [[RACObserve(self.itemData, extraImages)
      map:^id (NSArray<SPGamepediaImage *> *value) {
          ygstrongify(self);
          NSURL *URL = [self.itemData.item qiniuLargeURL];
          if (value) {
              NSMutableArray *imageURLs = URL ? [NSMutableArray arrayWithObject:URL] : [NSMutableArray array];
              for (SPGamepediaImage *aImage in value) {
                  [imageURLs addObject:[aImage imageURL:SPGamepediaImageScaleBest]];
              }
              return imageURLs;
          }else if (URL){
              return @[URL];
          }else{
              return nil;
          }
    }]
     subscribeNext:^(NSArray<NSURL *> *x) {
         ygstrongify(self);
         
         if (x == nil || x.count == 0 || x.count == 1) {
             self.hasExtraImages = NO;
             self.infoView.hidden = YES;
         }else{
             self.hasExtraImages = YES;
             [self.infoView setHidden:NO animated:YES];
         }
         
         NSMutableArray *infoList = [NSMutableArray array];
         NSMutableArray *URLs = [NSMutableArray array];
         for (NSInteger i = 0; i<x.count; i++) {
             SPItemBannerImageInfo *info = [[SPItemBannerImageInfo alloc] init:x[i]];
             info.index = i;
             info.imageCount = x.count;
             [infoList addObject:info];
             [URLs addObject:x[i]];
         }
         self.imageInfoList = infoList;
         self.imageURLs = URLs;
         [self.collectionView reloadData];
         if (infoList.count > 0) {
             [self updateCurImageIndex:0];
         }
     }];
    
    
}

- (void)updateImageInfoView
{
    self.infoView.shouldShow = self.imageInfoList.count > 1;
    [self.infoView update:self.imageInfoList[self.curIndex]];
}

- (void)reset
{
    self.imageInfoList = [NSMutableArray array];
    self.curIndex = 0;
}

- (SPItemBannerImageInfo *)imageInfoForURL:(NSURL *)URL
{
    NSString *url = URL.absoluteString;
    for (SPItemBannerImageInfo *info in self.imageInfoList) {
        if ([info.url.absoluteString isEqualToString:url]) {
            return info;
        }
    }
    return nil;
}

- (void)loadingImage:(NSURL *)URL received:(NSInteger)received expected:(NSInteger)expected
{
    SPItemBannerImageInfo *info = [self imageInfoForURL:URL];
    info.received = received;
    info.length = expected;
}

- (void)didLoadImage:(NSURL *)URL error:(NSError *)error
{
    SPItemBannerImageInfo *info = [self imageInfoForURL:URL];
    info.error = error;
    info.completed = YES;
}


#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageInfoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemBannerImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSPItemBannerImageCell forIndexPath:indexPath];
    
    NSURL *url = self.imageURLs[indexPath.item];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageAllowInvalidSSLCertificates;
    
    ygweakify(self);
    NSLog(@"load image: %@",url);
    [cell.imageView sd_setImageWithURL:url placeholderImage:nil options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        ygstrongify(self);
        RunOnMainQueue(^{
            [self loadingImage:targetURL received:receivedSize expected:expectedSize];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ygstrongify(self);
        [self didLoadImage:imageURL error:error];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemBannerImageCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:self.imageURLs animatedFromView:cell.imageView];
    [browser setInitialPageIndex:(int)indexPath.item];
    browser.delegate = self;
    [[self viewController] presentViewController:browser animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / CGRectGetWidth(scrollView.frame);
    [self updateCurImageIndex:index];
}

#pragma mark - IDMPhotoBrowserDelegate

- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photoBrowserIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index
{
    self.photoBrowserIndex = index;
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index
{
    photoBrowser.delegate = nil;
}

@end

