//
//  SPWorkshopResourceCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/20.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYWebImage.h>

@class SPWorkshopResource;

UIKIT_EXTERN NSString *const kSPWorkshopResourceCell;

@interface SPWorkshopResourceCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (strong, nonatomic) YYWebImageManager *manager;

- (void)configureWithResource:(SPWorkshopResource *)resource;

@end
