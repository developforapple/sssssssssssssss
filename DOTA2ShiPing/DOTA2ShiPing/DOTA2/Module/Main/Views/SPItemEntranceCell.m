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

- (void)configure:(SPItemEntranceConfig *)c
{
    self.titleLabel.text = c.title;
    self.imageView.image = [UIImage imageNamed:c.image];
}

- (void)configureWithEvent:(SPDotaEvent *)event
{
    self.titleLabel.text = event.name_loc ? : event.event_id;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:event.picture] placeholderImage:[UIImage imageNamed:@"Item_OffPrice"]];
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
