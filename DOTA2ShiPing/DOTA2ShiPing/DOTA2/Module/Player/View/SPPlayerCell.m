//
//  SPPlayerCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerCell.h"
#import "SPPlayer.h"

@implementation SPPlayerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.layoutMargins = UIEdgeInsetsZero;
    
    self.playerImageView.layer.masksToBounds = YES;
    self.playerImageView.layer.cornerRadius = 4.f;
    
    self.playerInfoBtn.tintColor = kRedColor;
}

- (void)configureWithPlayer:(SPPlayer *)player
{
    self->_player = player;
    
    [self.playerImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:player.avatar_url] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageContinueInBackground progress:nil completed:nil];
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
