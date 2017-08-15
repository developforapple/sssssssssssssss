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

// mode 为自动模式
YG_EXTERN SPItemListMode const kSPItemListModeAuto;

@interface SPItemListContainer : YGBaseViewCtrl


@property (strong, readonly, nonatomic) NSArray *items;
@property (assign, readonly, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) NSAttributedString *emptyDataNote;

// 一般不用设置。当需要segment透明的时候设置为一个合适的值
@property (strong, nonatomic) NSNumber *topInset;

// item 可以穿nil
- (void)update:(SPItemListMode)mode data:(NSArray *)items;

- (void)setupClearBackground;


@end
