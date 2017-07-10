//
//  BingoBarItem.m
//
//  Created by WangBo on 2017/5/3.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "BingoBarItem.h"
#import "BingoBarItemView.h"

@interface BingoBarItem ()
@property (assign, readwrite, nonatomic) BingoBarItemType type;
@property (strong, nonatomic) BingoBarItemView *itemView;
@end

@implementation BingoBarItem

- (instancetype)initWithType:(BingoBarItemType)type
                     content:(id)content
                      target:(id)target
                      action:(SEL)action
{
    BingoBarItemView *itemView = [BingoBarItemView viewWithType:type content:content];
    BingoBarItem *item = [[BingoBarItem alloc] initWithCustomView:itemView];
    item.itemView = itemView;
    item.hideBadgeAuto = YES;
    item.target = target;
    item.action = action;
    
    [itemView setupTarget:item action:@selector(btnAction:)];
    
    CGRect frame = itemView.frame;
    frame.size =  [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    itemView.frame = frame;
    
    self.type = type;
    
    return item;
}

+ (instancetype)itemWithType:(BingoBarItemType)type
                     content:(id)content
                      target:(id)target
                      action:(SEL)action
{
    return [[self alloc] initWithType:type content:content target:target action:action];
}

- (void)setBadge:(NSInteger)badge
{
    self.itemView.badge = badge;
}

- (NSInteger)badge
{
    return self.itemView.badge;
}

- (void)setBadgeStyle:(BingoBadgeStyle)badgeStyle
{
    self.itemView.badgeStyle = badgeStyle;
}

- (BingoBadgeStyle)badgeStyle
{
    return self.itemView.badgeStyle;
}

- (void)btnAction:(__unused UIButton *)btnß
{
    if (self.hideBadgeAuto) {
        self.badge = 0;
    }
    NO_WARNING_BEGIN(-Wundeclared-selector)
    NO_WARNING_BEGIN(-Warc-performSelector-leaks)
    if (self.target && self.action && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
    NO_WARNING_END
}

@end
