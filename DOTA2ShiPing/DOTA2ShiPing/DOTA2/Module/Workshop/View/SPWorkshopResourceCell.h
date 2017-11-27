//
//  SPWorkshopResourceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/20.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "FLAnimatedImageView.h"

@class SPWorkshopResource;

UIKIT_EXTERN NSString *const kSPWorkshopResourceCell;

@interface SPWorkshopResourceCell : SPCollectionViewCell
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (void)configureWithResource:(SPWorkshopResource *)resource;

@end
