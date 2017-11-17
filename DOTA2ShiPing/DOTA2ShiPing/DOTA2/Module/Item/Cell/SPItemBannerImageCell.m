//
//  SPItemBannerImageCell.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemBannerImageCell.h"

NSString *const kSPItemBannerImageCell = @"SPItemBannerImageCell";

@implementation SPItemBannerImageCell

- (void)setImageWithURL:(nullable NSURL *)url
               progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
              completed:(nullable SDExternalCompletionBlock)completedBlock
{
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageAllowInvalidSSLCertificates;
    
    ygweakify(self);
    [self.imageView sd_setImageWithURL:url placeholderImage:nil options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ygstrongify(self);
        
        if (image) {
            CGSize size = image.size;
            if (size.width < 120 && size.height < 120) {
                self.imageView.contentMode = UIViewContentModeCenter;
            }else{
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        }
        
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
    }];
}

@end
