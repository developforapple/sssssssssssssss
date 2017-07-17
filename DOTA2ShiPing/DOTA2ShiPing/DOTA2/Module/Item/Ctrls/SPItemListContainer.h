//
//  SPItemListContainer.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPItem.h"
#import "SPItemCommon.h"

@interface SPItemListContainer : YGBaseViewCtrl

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSAttributedString *emptyDataNote;
@property (assign, nonatomic) SPItemListMode mode;

// 一般不用设置。当需要segment透明的时候设置为一个合适的值
@property (strong, nonatomic) NSNumber *topInset;

- (void)updateWithMode:(SPItemListMode)mode;

- (void)setupClearBackground;


@end
