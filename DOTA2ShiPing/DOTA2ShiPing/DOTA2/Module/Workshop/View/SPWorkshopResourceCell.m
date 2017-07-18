//
//  SPWorkshopResourceCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/20.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopResourceCell.h"
#import "SPWorkshopModel.h"

#import "SPSteamAPI.h"
#import "SPDiskCacheControl.h"

@implementation SPWorkshopResourceCell

- (void)configureWithResource:(SPWorkshopResource *)resource
{
    ygweakify(self);
    
    if (resource.isVideo) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.image = [UIImage imageNamed:@"icon_video_play"];
        self.progressLabel.hidden = NO;
        self.progressLabel.text = @"点击播放视频";
        
    }else{
        BOOL isGif = resource.isGif;
        self.imageView.contentMode = UIViewContentModeCenter;
        NSURL *URL = isGif ? [resource fullURL] : [resource thumbURL] ;
        [self.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload | SDWebImageRefreshCached | SDWebImageContinueInBackground  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
            
            ygstrongify(self);
            CGFloat p = receivedSize/(CGFloat)expectedSize;
            self.progressLabel.hidden = NO;
            self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",p*100];
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            ygstrongify(self);
            self.progressLabel.hidden = YES;
            if (image) {
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
            
        }];
    }
}

@end


NSString * const kSPWorkshopResourceCell = @"SPWorkshopResourceCell";
