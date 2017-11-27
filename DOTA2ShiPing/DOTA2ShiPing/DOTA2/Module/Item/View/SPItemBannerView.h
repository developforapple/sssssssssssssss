//
//  SPItemBannerView.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPView.h"
#import "SDCycleScrollView.h"

@class SPItemSharedData;

typedef NS_ENUM(NSUInteger, SPItemBannerInfoType) {
    SPItemBannerInfoTypeProgress,       //进度
    SPItemBannerInfoTypePlayable,       //可播放类型
    SPItemBannerInfoTypeSize,           //大小
    SPItemBannerInfoTypeIndex           //索引
};

typedef NS_ENUM(NSUInteger, SPItemBannerPlayable) {
    SPItemBannerPlayableNone,   //不可播放
    SPItemBannerPlayableGif,    //GIF图
    SPItemBannerPlayableVideo,  //视频
    SPItemBannerPlayableAudio   //音频
};

@interface SPItemBannerImageInfo : SPObject
@property (assign, nonatomic) NSInteger index;                  //索引
@property (assign, nonatomic) NSInteger imageCount;             //图片数量
@property (copy, nonatomic) NSURL *url;                      //资源URL
@property (assign, nonatomic) SPItemBannerPlayable playable;    //可播放资源类型
@property (assign, nonatomic) NSInteger received;               //接收字节数
@property (assign, nonatomic) NSInteger length;                 //总字节数
@property (strong, nonatomic) NSError *error;                   //错误信息
@property (assign, nonatomic) BOOL completed;                   //已完成
- (instancetype)init:(NSURL *)URL;
- (CGFloat)progress;
- (NSString *)lengthDesc;
- (BOOL)isPlayable;
@end

@interface SPItemBannerInfoUnit : SPView
@property (assign, nonatomic) SPItemBannerInfoType type;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
- (void)update:(SPItemBannerImageInfo *)info;
@end


@interface SPItemBannerInfoView : SPView
@property (weak, nonatomic) IBOutlet SPItemBannerInfoUnit *progressUnit;
@property (weak, nonatomic) IBOutlet SPItemBannerInfoUnit *playableUnit;
@property (weak, nonatomic) IBOutlet SPItemBannerInfoUnit *sizeUnit;
@property (weak, nonatomic) IBOutlet SPItemBannerInfoUnit *indexUnit;

@property (assign, nonatomic) BOOL shouldShow;
- (void)update:(SPItemBannerImageInfo *)info;

@end

@interface SPItemBannerView : SPView
@property (weak, nonatomic) IBOutlet SPItemBannerInfoView *infoView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) SPItemSharedData *itemData;

- (void)setScrollProgress:(float)progress;

@end
