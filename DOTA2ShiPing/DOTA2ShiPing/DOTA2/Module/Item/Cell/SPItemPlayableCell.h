//
//  SPItemPlayableCell.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

YG_EXTERN NSString *const kSPItemPlayableCell;

@interface SPItemPlayableCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
