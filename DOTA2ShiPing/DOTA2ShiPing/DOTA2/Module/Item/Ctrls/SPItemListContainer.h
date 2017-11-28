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

@class SPItemListContainer;

@protocol SPItemListContainerDelegate <NSObject>
@optional
- (void)itemListContainerWillLoadMore:(SPItemListContainer *)container;
// 默认实现是显示详情页。实现此代理方法可以替换默认实现。
- (void)itemListContainer:(SPItemListContainer *)container didSelectedItem:(SPItem *)item;
@end

// mode 为自动模式
YG_EXTERN SPItemListMode const kSPItemListModeAuto;

@interface SPItemListContainer : YGBaseViewCtrl

@property (weak, nonatomic) id<SPItemListContainerDelegate> delegate;

// 是否支持loadMore 默认为NO
@property (assign, nonatomic) BOOL supportLoadMore;

@property (strong, readonly, nonatomic) NSArray<SPItem *> *items;
@property (assign, readonly, nonatomic) SPItemListMode mode;

@property (strong, nonatomic) NSAttributedString *emptyDataNote;

// 一般不用设置。当需要segment透明的时候设置为一个合适的值
@property (strong, nonatomic) NSNumber *topInset;

// item 可以穿nil
- (void)update:(SPItemListMode)mode data:(NSArray<SPItem *> *)items;

- (void)setupClearBackground;

// 新增数据
- (void)appendData:(NSArray<SPItem *> *)items;

@end
