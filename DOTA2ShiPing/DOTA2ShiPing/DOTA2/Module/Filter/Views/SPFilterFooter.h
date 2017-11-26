//
//  SPFilterFooter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPFilterGroup;

YG_EXTERN NSString *const kSPFilterFooter;

@interface SPFilterFooter : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, readonly, nonatomic) SPFilterGroup *group;

- (void)configure:(SPFilterGroup *)group;

@end
