//
//  SPItemCellModel.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "DDViewModel.h"
#import "SPItemCommon.h"

@class SPItem;

@interface SPItemLayout : SPObject
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat interitemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGSize preferImageSize;
@property (nonatomic) CGSize preferNameSize;

+ (SPItemLayout *)layoutWithMode:(SPItemListMode)mode;

@end

@interface SPItemCellModel : DDViewModel

- (SPItem *)item;

@property (assign, nonatomic) CGSize preferImageSize;

// table
@property (strong, nonatomic) NSArray *gradientColors;
@property (copy, nonatomic) NSString *typeString;
@property (copy, nonatomic) NSString *rarityString;

// grid 自动设置
@property (assign, nonatomic) CGSize nameSize;
@property (assign, nonatomic) CGPoint namePosition;
@property (copy, nonatomic) NSAttributedString *name;
// 额外手动
@property (assign, nonatomic) BOOL lineHidden;

// create之前需要先设置mode
@property (assign, nonatomic) SPItemListMode mode;

@end
