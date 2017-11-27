//
//  SPItemEntranceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "SPItemEntranceConfig.h"

@class SPDotaEvent;

#define kSPItemEntranceCell @"SPItemEntranceCell"

@interface SPItemEntranceCell : SPCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) SPItemEntranceUnit *unit;

- (void)configure:(SPItemEntranceUnit *)c;
- (void)configureWithEvent:(SPDotaEvent *)event;

@end
