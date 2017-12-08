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

typedef struct SPItemLayout {
    CGSize containerSize;
    SPItemListMode mode;
    float lineSpacing;
    float interitemSpacing;
    CGSize itemSize;
    UIEdgeInsets sectionInset;
    CGSize preferImageSize;
    CGSize preferNameSize;
} SPItemLayout;

YG_EXTERN
SPItemLayout
createItemLayout(SPItemListMode mode, CGSize containerSize);

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
