//
//  YGRefreshHeader.h
//  Golf
//
//  Created by bo wang on 16/6/16.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>


@interface YGRefreshHeader : MJRefreshNormalHeader
@end

// 只有菊花
@interface YGRefreshFooter : MJRefreshAutoNormalFooter
@property (copy, nonatomic) NSString *noMoreDataNotice;
@end

@protocol YGRefreshDelegate <NSObject>
@optional
- (void)refreshHeaderBeginRefreshing:(UIScrollView *)scrollView;
- (void)refreshFooterBeginRefreshing:(UIScrollView *)scrollView;
@end

typedef NS_ENUM(NSUInteger, YGRefreshType) {
    YGRefreshTypeHeader,
    YGRefreshTypeFooter,
};

typedef void(^YGRefreshCallback)(YGRefreshType type);

@interface UIScrollView (Refresh)

@property (assign, nonatomic) BOOL refreshHeaderEnable;
@property (assign, nonatomic) BOOL refreshFooterEnable;
@property (copy, nonatomic) YGRefreshCallback refreshCallback;
@property (weak, nonatomic) id<YGRefreshDelegate> refreshDelegate;
@property (copy, nonatomic) NSString *noMoreDataNotice;

- (void)refreshHeader:(BOOL)headerEnabled
               footer:(BOOL)footerEnabled
             delegate:(id <YGRefreshDelegate>)delegate;
- (void)refreshHeader:(BOOL)headerEnabled
               footer:(BOOL)footerEnabled
             callback:(YGRefreshCallback)callback;

- (void)resetRefreshing;
- (void)endHeaderRefreshing;
- (void)endFooterRefreshing;
- (void)setNoMoreData;

@end
