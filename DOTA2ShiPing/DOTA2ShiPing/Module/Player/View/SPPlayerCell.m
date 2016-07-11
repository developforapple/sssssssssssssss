//
//  SPPlayerCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerCell.h"
#import "SPPlayer.h"
#import "SPMacro.h"
#import "YYWebImage.h"

@implementation SPPlayerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.layoutMargins = UIEdgeInsetsZero;
    
    self.playerImageView.layer.masksToBounds = YES;
    self.playerImageView.layer.cornerRadius = 4.f;
    
    self.playerInfoBtn.tintColor = AppBarColor;
}

- (void)configureWithPlayer:(SPPlayer *)player
{
    self->_player = player;
    
    [self.playerImageView yy_setImageWithURL:[NSURL URLWithString:player.avatar_url] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    self.playerNameLabel.text = player.name;
    self.playerDescLabel.text = player.steam_id.description;
}

- (IBAction)showPlayerInfo:(UIButton *)sender
{
    if (self.infoBtnAction) {
        self.infoBtnAction(self.player);
    }
}

@end


NSString *const kSPPlayerCell = @"SPPlayerCell";