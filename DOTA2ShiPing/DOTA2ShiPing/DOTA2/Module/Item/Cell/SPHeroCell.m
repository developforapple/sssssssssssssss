//
//  SPHeroCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPHeroCell.h"

#import "YYWebImage.h"

@interface SPHeroCell ()
@property (strong, nonatomic) CAGradientLayer *gLayer;
@end

@implementation SPHeroCell

- (void)awakeFromNib
{
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
    
    NSArray *releaseLog =
    @[@{@"version":@"1.0",
        @"build":@"1.0.65",
        @"desc":@"“饰品总汇”重生！\n\n全新的设计，重新Coding，一切推倒重来只为情怀。"}];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gLayer.frame = self.bounds;
}

- (void)configure:(SPHero *)hero
{
    _hero = hero;
    self.titleLabel.text = hero.name_cn;
    
    NSString *name = hero.name;
    NSRange range = [name rangeOfString:@"npc_dota_hero_"];
    if (range.location != NSNotFound) {
        name = [hero.name substringFromIndex:range.location + range.length];
    }
    NSString *url = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_full.png",name];
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
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
