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
#import "YYWebImage+Add.h"
#import "SPDiskCacheControl.h"
#import <YYWebImage.h>

@implementation SPWorkshopResourceCell

- (void)configureWithResource:(SPWorkshopResource *)resource
{
    ygweakify(self);
    
    if (resource.isVideo) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.image = [UIImage imageNamed:@"icon_video_play"];
        self.progressLabel.hidden = NO;
        self.progressLabel.text = @"点击播放视频";
        
    }else if (resource.isGif){
        
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.imageView yy_setImageWithURL:[resource fullURL] placeholder:[UIImage imageNamed:@"logo"] options:YYWebImageOptionProgressive | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation | YYWebImageOptionNotBeCanceled manager:[SPDiskCacheControl workshopImageManager] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            ygstrongify(self);
            
            CGFloat received = receivedSize/1024.f;
            CGFloat expected = expectedSize/1024.f;
            self.progressLabel.hidden = NO;
            self.progressLabel.text = [NSString stringWithFormat:@"GIF %.0fkb/%.0fkb %.1f%%",received,expected,100*received/expected];
            
        } transform:nil completion:^(UIImage *  image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            ygstrongify(self);
            self.progressLabel.hidden = YES;
            if (image) {
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        }];
        
    }else{
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.imageView yy_setImageWithURL:[resource thumbURL] placeholder:[UIImage imageNamed:@"logo"] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation manager:[SPDiskCacheControl workshopImageManager] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            ygstrongify(self);
            CGFloat p = receivedSize/(CGFloat)expectedSize;
            self.progressLabel.hidden = NO;
            self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",p*100];
        } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
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
