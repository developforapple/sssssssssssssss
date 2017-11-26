//
//  SPFilterViewCtrl.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@class SPBaseFilter;

@interface SPFilterViewCtrl : YGBaseViewCtrl

@property (strong, nonatomic) __kindof SPBaseFilter *filter;

- (UICollectionView *)collectionView;

@end
