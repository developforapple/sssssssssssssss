//
//  BingoBarItemView.m
//
//  Created by WangBo on 2017/5/3.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "BingoBarItemView.h"
#import "ReactiveObjC.h"

@interface BingoBarItemView ()
@property (strong, nonatomic) id content;
@property (assign, readwrite, nonatomic) BingoBarItemType type;
@end

@implementation BingoBarItemView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _type = BingoBarItemTypeText;
        _badgeStyle = BingoBadgeStyleSystem;
        _badge = 0;
    }
    return self;
}

+ (instancetype)viewWithType:(BingoBarItemType)type
                     content:(id)content
{
    BingoBarItemView *view = [[[NSBundle mainBundle] loadNibNamed:@"BingoBarItemView" owner:nil options:nil] firstObject];
    [view setup:type content:content];
    return view;
}

- (void)setup:(BingoBarItemType)type content:(id)content
{
    bingoWeakify(self);
    [RACObserve(self.actionBtn, highlighted)
     subscribeNext:^(NSNumber *x) {
         bingoStrongify(self);
         self.contentImageView.highlighted = [x boolValue];
         self.contentLabel.highlighted = [x boolValue];
     }];
    
    self.type = type;
    self.content = content;
    switch (type) {
        case BingoBarItemTypeText:{
            self.contentImageView.hidden = YES;
            self.contentLabel.hidden = NO;
            
            if ([content isKindOfClass:[NSString class]]) {
                self.contentLabel.text = content;
            }
            
        }   break;
        case BingoBarItemTypeInternal:{
            self.contentImageView.hidden = NO;
            self.contentLabel.hidden = YES;
            
            if ([content isKindOfClass:[NSNumber class]]) {
                BingoBarItemInternalType internalType = [content integerValue];
                NSString *iconName_n;
                NSString *iconName_h;
                switch (internalType) {
                    case BingoBarItemInternalType_:{
                    }   break;
                }
                self.contentImageView.image = [UIImage imageNamed:iconName_n];
                self.contentImageView.highlightedImage = [UIImage imageNamed:iconName_h];
            }
            
        }   break;
        case BingoBarItemTypeImage:{
            self.contentImageView.hidden = NO;
            self.contentLabel.hidden = YES;
            
            if ([content isKindOfClass:[UIImage class]]) {
                self.contentImageView.image = content;
            }else if ([content isKindOfClass:[NSString class]]){
                
                [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:content]];
            }
        }   break;
    }
    [self sizeToFit];
}

- (void)updateBadge
{
    if (self.badge == 0) {
        self.badgeView.hidden = YES;
        self.redDotView.hidden = YES;
    }else{
        switch (self.badgeStyle) {
            case BingoBadgeStyleRedDot:{
                self.badgeView.hidden = YES;
                self.redDotView.hidden = NO;
            }   break;
            case BingoBadgeStyleSystem:{
                self.redDotView.hidden = YES;
                self.badgeLabel.text = [@(self.badge) stringValue];
                self.badgeView.hidden = NO;
            }   break;
            case BingoBadgeStyleMax99:{
                self.redDotView.hidden = YES;
                self.badgeLabel.text = self.badge>99?@"99+":[@(self.badge) stringValue];
                self.badgeView.hidden = NO;
            }   break;
        }
    }
}

- (void)setBadge:(NSInteger)badge
{
    _badge = MAX(0, badge);
    [self updateBadge];
}

- (void)setBadgeStyle:(BingoBadgeStyle)badgeStyle
{
    _badgeStyle = badgeStyle;
    [self updateBadge];
}

- (void)setupTarget:(id)target action:(SEL)action
{
    [self.actionBtn removeAllTargets];
    [self.actionBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
