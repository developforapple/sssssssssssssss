//
//  SPItemEntranceCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemEntranceCell.h"
#import "SPDotaEvent.h"

@implementation SPItemEntranceCell

- (void)configure:(SPItemEntranceUnit *)c
{
    self.titleLabel.text = c.title;
    if (c.imageUrl) {
        
        NSURL *URL = [NSURL URLWithString:c.imageUrl];
        UIImage *placeholder = c.lastImage?:[UIImage imageNamed:c.defaultImage];
        SDWebImageOptions options = SDWebImageLowPriority | SDWebImageContinueInBackground | SDWebImageAvoidAutoSetImage;
        
        NSInteger hash = URL.hash;
        ygweakify(self);
        [self.imageView sd_setImageWithURL:URL placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSInteger hash2 = imageURL.hash;
            NSInteger hash3 = hash;
            if (hash2 == hash3 && image) {
                ygstrongify(self);
                [UIView transitionWithView:self.imageView duration:.8f options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.imageView.image = image;
                } completion:^(BOOL finished) {
                    c.lastImage = image;
                }];
            }
        }];
    }else{
        self.imageView.image = [UIImage imageNamed:c.defaultImage];
    }
}

- (void)configureWithEvent:(SPDotaEvent *)event
{
    self.titleLabel.text = event.name_loc ? : event.event_id;
    self.imageView.image = [UIImage imageNamed:event.image_name] ?: [UIImage imageNamed:@"Item_OffPrice"];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [UIView animateWithDuration:.2f animations:^{
        self.blurView.alpha = highlighted?0.f:1.f;
    } completion:^(BOOL finished) {
        
    }];
}

@end
