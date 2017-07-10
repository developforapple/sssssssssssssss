//
//  YGRefreshHeader.m
//  Golf
//
//  Created by bo wang on 16/6/16.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "YGRefreshComponent.h"

@interface YGRefreshHeader ()
@end

@implementation YGRefreshHeader

- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end

@implementation YGRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.refreshingTitleHidden = YES;
    self.triggerAutomaticallyRefreshPercent = -4.f;
    
    self.stateLabel.hidden = YES;
    [self setTitle:self.noMoreDataNotice?:@"数据已加载完毕" forState:MJRefreshStateNoMoreData];
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = RGBColor(187, 187, 187, 1);
}

- (void)setNoMoreDataNotice:(NSString *)noMoreDataNotice
{
    _noMoreDataNotice = [noMoreDataNotice copy];
    [self setTitle:noMoreDataNotice?:@"数据已加载完毕" forState:MJRefreshStateNoMoreData];
}

- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    [self updateStateLabelVisible];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    [self updateStateLabelVisible];
}

- (void)updateStateLabelVisible
{
    CGFloat scrollViewH = CGRectGetHeight(self.scrollView.bounds);
    CGFloat y = CGRectGetMinY(self.frame);
    
    // footer必须在屏幕之外
    BOOL condition1 = y>=scrollViewH;
    // 没有更多数据
    BOOL condition2 = self.state==MJRefreshStateNoMoreData;
    
    // 满足上述两条件下才显示状态提示
    self.stateLabel.hidden = !(condition1&&condition2);
}

@end

static const void *kHeaderEnableKey = &kHeaderEnableKey;
static const void *kFooterEnableKey = &kFooterEnableKey;
static const void *kRefreshCallbackKey = &kRefreshCallbackKey;
static const void *kRefreshDelegateKey = &kRefreshDelegateKey;

@implementation UIScrollView (Refresh)

- (BOOL)refreshHeaderEnable
{
    return [objc_getAssociatedObject(self, kHeaderEnableKey) boolValue];
}

- (void)setRefreshHeaderEnable:(BOOL)refreshHeaderEnable
{
    objc_setAssociatedObject(self, kHeaderEnableKey, @(refreshHeaderEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!refreshHeaderEnable) {
        self.mj_header = nil;
    }else{
        bingoWeakify(self);
        self.mj_header = [YGRefreshHeader headerWithRefreshingBlock:^{
            bingoStrongify(self);
            if ([self.refreshDelegate respondsToSelector:@selector(refreshHeaderBeginRefreshing:)]) {
                [self.refreshDelegate refreshHeaderBeginRefreshing:self];
            }
            if (self.refreshCallback) {
                self.refreshCallback(YGRefreshTypeHeader);
            }
        }];
    }
}

- (BOOL)refreshFooterEnable
{
    return [objc_getAssociatedObject(self, kFooterEnableKey) boolValue];
}

- (void)setRefreshFooterEnable:(BOOL)refreshFooterEnable
{
    objc_setAssociatedObject(self, kFooterEnableKey, @(refreshFooterEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!refreshFooterEnable) {
        self.mj_footer = nil;
    }else{
        bingoWeakify(self);
        self.mj_footer = [YGRefreshFooter footerWithRefreshingBlock:^{
            bingoStrongify(self);
            if ([self.refreshDelegate respondsToSelector:@selector(refreshFooterBeginRefreshing:)]) {
                [self.refreshDelegate refreshFooterBeginRefreshing:self];
            }
            if (self.refreshCallback) {
                self.refreshCallback(YGRefreshTypeFooter);
            }
        }];
    }
}

- (void)setRefreshCallback:(YGRefreshCallback)refreshCallback
{
    objc_setAssociatedObject(self, kRefreshCallbackKey, refreshCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YGRefreshCallback)refreshCallback
{
    return objc_getAssociatedObject(self, kRefreshCallbackKey);
}

- (void)setRefreshDelegate:(id<YGRefreshDelegate>)refreshDelegate
{
    objc_setAssociatedObject(self, kRefreshDelegateKey, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<YGRefreshDelegate>)refreshDelegate
{
    return objc_getAssociatedObject(self, kRefreshDelegateKey);
}

- (void)setNoMoreDataNotice:(NSString *)noMoreDataNotice
{
    YGRefreshFooter *footer = (YGRefreshFooter *)self.mj_footer;
    if ([footer isKindOfClass:[YGRefreshFooter class]]) {
        footer.noMoreDataNotice = noMoreDataNotice;
    }
}

- (NSString *)noMoreDataNotice
{
    YGRefreshFooter *footer = (YGRefreshFooter *)self.mj_footer;
    if ([footer isKindOfClass:[YGRefreshFooter class]]) {
        return footer.noMoreDataNotice;
    }
    return nil;
}

- (void)refreshHeader:(BOOL)headerEnabled
               footer:(BOOL)footerEnabled
             delegate:(id <YGRefreshDelegate>)delegate
{
    self.refreshHeaderEnable = headerEnabled;
    self.refreshFooterEnable = footerEnabled;
    self.refreshDelegate = delegate;
}

- (void)refreshHeader:(BOOL)headerEnabled
               footer:(BOOL)footerEnabled
             callback:(YGRefreshCallback)callback
{
    self.refreshHeaderEnable = headerEnabled;
    self.refreshFooterEnable = footerEnabled;
    self.refreshCallback = callback;
}

- (void)resetRefreshing
{
    [self endHeaderRefreshing];
    [self endFooterRefreshing];
}

- (void)endHeaderRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)endFooterRefreshing
{
    if (self.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.mj_footer resetNoMoreData];
    }else{
        [self.mj_footer endRefreshing];
    }
}

- (void)setNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
