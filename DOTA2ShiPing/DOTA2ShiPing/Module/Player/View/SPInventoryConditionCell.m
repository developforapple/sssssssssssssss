//
//  SPInventoryConditionCell.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/12.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPInventoryConditionCell.h"
#import "SPMacro.h"
#import <YYWebImage.h>

@implementation SPInventoryConditionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)/2;
    
    self.closeBtn.backgroundColor = AppBarColor;
    self.closeBtn.layer.masksToBounds = YES;
    self.closeBtn.layer.cornerRadius = CGRectGetWidth(self.closeBtn.frame)/2;
}

- (IBAction)close:(UIButton *)btn
{
    if (self.willRemoveCondition) {
        self.willRemoveCondition(self.type);
    }
}

- (void)configureWithCondition:(SPInventoryFilterCondition *)condition
{
    if (!condition) return;
    
    switch (self.type) {
        case SPConditionTypeHero: {
            SPHero *hero = condition.hero;
            if (hero) {
                self.closeBtn.hidden = NO;
                
                NSString *name = hero.name;
                NSRange range = [name rangeOfString:@"npc_dota_hero_"];
                if (range.location != NSNotFound) {
                    name = [hero.name substringFromIndex:range.location + range.length];
                }
                NSString *url = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_full.png",name];
                [self.imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
                
                self.titleLabel.text = hero.name_cn;
                
                
            }else{
                self.imageView.image = nil;
                self.closeBtn.hidden = YES;
                self.titleLabel.text = @"选择英雄";
            }
            break;
        }
        case SPConditionTypeQuality: {
            SPItemQuality *quality = condition.quality;
            
            if (quality) {
                
                self.closeBtn.hidden = NO;
                self.titleLabel.text = quality.name_cn;
                
            }else{
                self.imageView.image = nil;
                self.closeBtn.hidden = YES;
                self.titleLabel.text = @"选择品质";
            }
            break;
        }
        case SPConditionTypeRarity: {
            SPItemRarity *rarity = condition.rarity;
            if (rarity) {
                self.closeBtn.hidden = NO;
                self.titleLabel.text = rarity.name_cn;
            }else{
                self.closeBtn.hidden = YES;
                self.titleLabel.text = @"选择稀有度";
            }
            break;
        }
    }
}

@end

NSString *const kSPInventoryConditionCell = @"SPInventoryConditionCell";