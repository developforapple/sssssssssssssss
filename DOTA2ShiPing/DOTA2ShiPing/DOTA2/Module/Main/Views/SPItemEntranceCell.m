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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIInterpolatingMotionEffect *xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue = @-10;
    xEffect.maximumRelativeValue = @10;
    UIInterpolatingMotionEffect *yEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yEffect.minimumRelativeValue = @-10;
    yEffect.maximumRelativeValue = @10;
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xEffect,yEffect];
    [self.imageView addMotionEffect:group];
}

- (void)configure:(SPItemEntranceUnit *)c
{
    self.unit = c;
    self.titleLabel.text = c.title;
    if (c.imageUrl) {
        
        NSURL *URL = [NSURL URLWithString:c.imageUrl];
        UIImage *placeholder = c.lastImage?:[UIImage imageNamed:c.defaultImage];
        SDWebImageOptions options = SDWebImageLowPriority | SDWebImageContinueInBackground | SDWebImageAvoidAutoSetImage;
        
        ygweakify(self);
        [self.imageView sd_setImageWithURL:URL placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ygstrongify(self);
            if (self.unit.imageUrl && [imageURL.absoluteString isEqualToString:self.unit.imageUrl]) {
                [self setupImageViewImage:image];
            }
        }];
    }else{
        self.imageView.image = [UIImage imageNamed:c.defaultImage];
    }
}

- (void)setupImageViewImage:(UIImage *)image
{
    RunOnGlobalQueue(^{
        UIImage *scaledImage = [image imageByResizeToSize:CGSizeMake(self.imageView.bounds.size.width*2, self.imageView.bounds.size.width*2) contentMode:self.imageView.contentMode];
        RunOnMainQueue(^{
            [UIView transitionWithView:self.imageView duration:.6f options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut animations:^{
                self.imageView.image = scaledImage;
            } completion:^(BOOL finished) {
                self.unit.lastImage = scaledImage;
            }];
        });
    });
}

- (void)configureWithEvent:(SPDotaEvent *)event
{
    self.titleLabel.text = event.name_loc ? : event.event_id;
    self.imageView.image = [UIImage imageNamed:event.image_name] ?: [UIImage imageNamed:@"Unit_OffPrice"];
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
