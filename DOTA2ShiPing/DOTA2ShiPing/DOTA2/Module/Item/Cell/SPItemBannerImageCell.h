//
//  SPItemBannerImageCell.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FLAnimatedImage;

YG_EXTERN NSString *const kSPItemBannerImageCell;

@interface SPItemBannerImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end
