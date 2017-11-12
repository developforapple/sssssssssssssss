//
//  SPItemBannerView.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@class SPItemSharedData;

@interface SPItemBannerView : UIView
@property (weak, nonatomic) IBOutlet SDCycleScrollView *imageView;
@property (weak, nonatomic) IBOutlet UIView *imageCounterView;
@property (weak, nonatomic) IBOutlet UILabel *imageCounterLabel;
@property (weak, nonatomic) IBOutlet UIView *imageSizeView;
@property (weak, nonatomic) IBOutlet UILabel *imageSizeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imagePrepareIndicator;
@property (weak, nonatomic) IBOutlet UIView *imageProgressView;
@property (weak, nonatomic) IBOutlet UILabel *imageProgressLabel;

@property (strong, nonatomic) SPItemSharedData *itemData;

- (void)setScrollProgress:(float)progress;

@end

@interface SPItemBannerImageInfo : NSObject
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) NSInteger received;
@property (assign, nonatomic) NSInteger length;
@property (strong, nonatomic) NSError *error;
@property (assign, nonatomic) BOOL completed;
- (instancetype)init:(NSString *)URL;
- (CGFloat)progress;
- (NSString *)lengthDesc;
@end
