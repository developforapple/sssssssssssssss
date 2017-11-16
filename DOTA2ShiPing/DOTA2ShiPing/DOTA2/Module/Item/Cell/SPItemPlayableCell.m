//
//  SPItemPlayableCell.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPlayableCell.h"

NSString *const kSPItemPlayableCell = @"SPItemPlayableCell";

@interface SPItemPlayableCell ()
@end

@implementation SPItemPlayableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.playIndicator.image = [[UIImage imageNamed:@"icon_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playIndicator.tintColor = [UIColor whiteColor];
}

@end
