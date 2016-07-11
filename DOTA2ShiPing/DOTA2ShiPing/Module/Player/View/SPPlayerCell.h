//
//  SPPlayerCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const kSPPlayerCell;

@class SPPlayer;

@interface SPPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerInfoBtn;

@property (strong, readonly, nonatomic) SPPlayer *player;
- (void)configureWithPlayer:(SPPlayer *)player;

@property (copy, nonatomic) void (^infoBtnAction)(SPPlayer *);

@end
