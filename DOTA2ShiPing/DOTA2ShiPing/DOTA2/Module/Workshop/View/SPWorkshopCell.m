//
//  SPWorkshopCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopCell.h"
#import "SPWorkshop.h"
#import "SPDiskCacheControl.h"

@interface SPWorkshopCell ()
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, readwrite, nonatomic) SPWorkshopUnit *unit;
@end

@implementation SPWorkshopCell

- (void)configureWithUnit:(SPWorkshopUnit *)unit
{
    self.unit = unit;
    CGSize size = self.bounds.size;
    NSURL *URL = [unit imageURLForSize:CGSizeMake(size.width*2, size.height*2)];
    
    static UIImage *placeholder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placeholder = [UIImage imageNamed:@"logo"];
    });
    self.imageView.contentMode = UIViewContentModeCenter;
    ygweakify(self);
    
    [self.imageView sd_setImageWithURL:URL placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ygstrongify(self);
        if (image) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.effectView = [[UIVisualEffectView alloc] init];
        self.effectView.frame = self.bounds;
        self.effectView.backgroundColor = [UIColor clearColor];
        self.effectView.hidden = YES;
        self.effectView.alpha = 0.f;
        [self addSubview:self.effectView];
    
        
        self.effectView.hidden = NO;
        [UIView animateWithDuration:.2f animations:^{
            
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            
            self.effectView.alpha = 1.f;
            self.effectView.effect = blur;
            
            UIVisualEffectView *ev = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blur]];
            ev.frame = self.effectView.bounds;
            [self.effectView.contentView addSubview:ev];
            
            NSString *text = [NSString stringWithFormat:@"%@\n\n作者:%@",self.unit.title,[self.unit.authors firstObject]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:ev.bounds];
            label.text = text;
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            [ev.contentView addSubview:label];
        }];
        
    }else{
        ygweakify(self);
        [self.effectView setHidden:YES animated:YES completion:^{
            ygstrongify(self);
            [self.effectView removeFromSuperview];
            self.effectView = nil;
        }];
    }
}

@end

NSString *const kSPWorkshopCell = @"SPWorkshopCell";
