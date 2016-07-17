//
//  SPWorkshopCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPWorkshopUnit;
@class YYAnimatedImageView;

UIKIT_EXTERN NSString *const kSPWorkshopCell;

@interface SPWorkshopCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;

@property (strong, readonly, nonatomic) SPWorkshopUnit *unit;
- (void)configureWithUnit:(SPWorkshopUnit *)unit;

@end
