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
@import ReactiveObjC;
@import IDMPhotoBrowser;

static const NSInteger kInvalidValue = -1;

@interface SPItemBannerView () <SDCycleScrollViewDelegate,IDMPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableDictionary<NSString *,SPItemBannerImageInfo *> *imageInfoCache;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *,SPItemBannerImageInfo *> *imageList;
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
    
    [self reset];
    
    self.imageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.imageView.infiniteLoop = NO;
    self.imageView.showPageControl = NO;
    self.imageView.placeholderImage = nil;
    self.imageView.autoScroll = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.delegate = self;
}

- (void)dealloc
{
    if (!_disposable.isDisposed) {
        [_disposable dispose];
    }
    _disposable = nil;
    
    [_imageInfoCache removeAllObjects];
    [_imageList removeAllObjects];
    _imageView.delegate = nil;
}

- (void)setCurIndex:(NSInteger)curIndex
{
    NSInteger preIndex = _curIndex;
    _curIndex = curIndex;
    
    if (preIndex == curIndex) return;
    
    SPItemBannerImageInfo *info = self.imageList[@(curIndex)];
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
         [self updateImageInfo];
     }];
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
    
    self.imageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
}

- (void)setScrollProgress:(float)progress
{
    float alpha = (progress - 0.1) / (1 - 0.5 - 0.1);
    alpha = Confine(alpha, 1, 0);
    self.imageCounterView.alpha = alpha;
    self.imageProgressView.alpha = alpha;
    self.imageSizeView.alpha = alpha;
}

- (void)update
{
    ygweakify(self);
    [[RACObserve(self.itemData, extraImages)
      map:^id (NSArray<SPGamepediaImage *> *value) {
          ygstrongify(self);
          NSURL *URL = [self.itemData.item qiniuLargeURL];
          if (value) {
              NSMutableArray *extraImageURLs = URL ? [NSMutableArray arrayWithObject:URL] : [NSMutableArray array];
              for (SPGamepediaImage *aImage in value) {
                  [extraImageURLs addObject:[aImage imageURL:SPGamepediaImageScaleBest]];
              }
              return extraImageURLs;
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
             self.imageCounterView.hidden = YES;
         }else{
             self.hasExtraImages = YES;
             self.imageCounterLabel.text = [NSString stringWithFormat:@"1/%d",x.count];
             [self.imageCounterView setHidden:NO animated:YES];
         }
         
         self.imageView.imageURLStringsGroup = x;
     }];
}

- (void)updateImageInfo
{
    if (!self.hasExtraImages) {
        self.imageCounterView.hidden = self.imageSizeView.hidden = self.imageProgressView.hidden = YES;
        return;
    }
    
    SPItemBannerImageInfo *info = self.imageList[@(self.curIndex)];
    if (!info) {
        self.imageCounterView.hidden = NO;
        self.imageSizeView.hidden = self.imageProgressView.hidden = YES;
        return;
    }
    
    self.imageCounterView.hidden = NO;
    
    if (info.completed) {
        
        [self.imagePrepareIndicator stopAnimating];
        
        if (info.length == kInvalidValue) {
            self.imageSizeView.hidden = YES;
        }else{
            self.imageSizeView.hidden = NO;
            self.imageSizeLabel.text = [info lengthDesc];
        }
        self.imageProgressView.hidden = YES;
        return;
    }
    
    self.imageSizeView.hidden = NO;
    if (info.length == kInvalidValue) {
        self.imageSizeLabel.hidden = YES;
        [self.imagePrepareIndicator startAnimating];
    }else{
        self.imageSizeLabel.hidden = NO;
        [self.imagePrepareIndicator stopAnimating];
    }
    self.imageSizeLabel.text = [info lengthDesc];
    
    if ( info.length == kInvalidValue || info.received == kInvalidValue ) {
        self.imageProgressView.hidden = YES;
    }else {
        self.imageProgressView.hidden = NO;
        self.imageProgressLabel.text = [NSString stringWithFormat:@"%.0f%%",[info progress] * 100];
    }
}

- (void)reset
{
    self.imageInfoCache = [NSMutableDictionary dictionary];
    self.imageList = [NSMutableDictionary dictionary];
    self.curIndex = 0;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:cycleScrollView.imageURLStringsGroup animatedFromView:cycleScrollView];
    [browser setInitialPageIndex:index];
    browser.delegate = self;
    [[self viewController] presentViewController:browser animated:YES completion:nil];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.curIndex = index;
    self.imageCounterLabel.text = [NSString stringWithFormat:@"%d/%d",index+1,cycleScrollView.imageURLStringsGroup.count];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView willLoadImage:(NSString *)url atIndex:(NSInteger)index
{
    SPItemBannerImageInfo *info = self.imageInfoCache[url];
    if (!info) {
        info = [[SPItemBannerImageInfo alloc] init:url];
        self.imageInfoCache[url] = info;
    }
    self.imageList[@(index)] = info;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView loading:(NSString *)url received:(NSInteger)receivedLength total:(NSInteger)totalLength
{
    SPItemBannerImageInfo *info = self.imageInfoCache[url];
    info.received = receivedLength;
    info.length = totalLength;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didLoadimage:(NSString *)url error:(NSError *)error
{
    SPItemBannerImageInfo *info = self.imageInfoCache[url];
    info.error = error;
    info.completed = YES;
}

#pragma mark - IDMPhotoBrowserDelegate

- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser
{
    [self.imageView setCurrentIndex:self.photoBrowserIndex];
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


@implementation SPItemBannerImageInfo
- (instancetype)init:(NSString *)URL
{
    self = [super init];
    if (self) {
        self.url = URL;
        self.received = kInvalidValue;
        self.length = kInvalidValue;
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
@end
