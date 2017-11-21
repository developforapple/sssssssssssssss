//
//  SPItemEntranceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPItemEntranceConfig.h"

@class SPDotaEvent;

#define kSPItemEntranceCell @"SPItemEntranceCell"

@interface SPItemEntranceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configure:(SPItemEntranceUnit *)c;
- (void)configureWithEvent:(SPDotaEvent *)event;

@end
