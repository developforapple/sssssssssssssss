//
//  SPHeroCell.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "SPHero.h"

#define kSPHeroCell @"SPHeroCell"

@interface SPHeroCell : SPCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *leftLine;

@property (strong, readonly, nonatomic) SPHero *hero;
- (void)configure:(SPHero *)hero;

@end
