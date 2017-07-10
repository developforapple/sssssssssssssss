//
//  SPInventoryConditionCell.h
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/12.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPInventoryFilter.h"

FOUNDATION_EXTERN NSString *const kSPInventoryConditionCell;

@interface SPInventoryConditionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (assign, nonatomic) SPConditionType type;

- (void)configureWithCondition:(SPInventoryFilterCondition *)condition;

@property (copy, nonatomic) void (^willRemoveCondition)(SPConditionType type);

@end
