//
//  SPItemPlayableCell.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/15.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"

YG_EXTERN NSString *const kSPItemPlayableCell;

@interface SPItemPlayableCell : SPCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
