//
//  SPSearchCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPTableViewCell.h"

@class SPPlayer;

FOUNDATION_EXTERN NSString *const kSPSearchCell;

@interface SPSearchCell : SPTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *spTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *spDetailTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spImageViewWidthConstraint;

- (void)configureWithText:(NSString *)text;
- (void)configureWithUser:(SPPlayer *)user;

@end
