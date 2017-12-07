//
//  SPIAPCell.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPCell.h"

NSString *const kSPIAPCell = @"SPIAPCell";

@implementation SPIAPCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.iapDesc.preferredMaxLayoutWidth = CGRectGetWidth(self.iapDesc.bounds);
}

@end
