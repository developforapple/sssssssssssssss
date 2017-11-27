//
//  SPWorkshopCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "FLAnimatedImageView.h"

@class SPWorkshopUnit;

UIKIT_EXTERN NSString *const kSPWorkshopCell;

@interface SPWorkshopCell : SPCollectionViewCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;

@property (strong, readonly, nonatomic) SPWorkshopUnit *unit;
- (void)configureWithUnit:(SPWorkshopUnit *)unit;

@end
