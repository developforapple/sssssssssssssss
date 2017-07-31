//
//  SPHeroCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPHeroCell.h"

@interface SPHeroCell ()
@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPHeroCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.frame;
    layer.startPoint = CGPointMake(.5f, .5f);
    layer.endPoint = CGPointMake(.5f, 1.f);
    layer.locations = @[@.2f,@1.f];
    layer.colors = @[(id)[UIColor clearColor].CGColor,
                     (id)RGBColor(0, 0, 0, 0.8f).CGColor];
    [self.blurView.layer addSublayer:layer];
    self.gLayer = layer;
    
    [self.blurView bringSubviewToFront:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gLayer.frame = self.bounds;
}

- (void)configure:(SPHero *)hero
{
    _hero = hero;
    self.titleLabel.text = hero.name_loc;
    
    NSString *url = [hero smallImageURL];

//    NSString *url = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_full.png",name];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"HeroPlacehodler"] options:SDWebImageRetryFailed | SDWebImageContinueInBackground ];
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
