//
//  SPFilterCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"

@class SPFilterUnit;

YG_EXTERN NSString *const kSPFilterCell;
YG_EXTERN NSString *const kSPFilterInputCell;

@interface SPFilterCell : SPCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldWidthConstraint;

@property (strong, readonly, nonatomic) SPFilterUnit *unit;

@property (copy, nonatomic) void (^inputContentDidChanged)(SPFilterUnit *unit);

- (void)configure:(SPFilterUnit *)unit;

@end
