//
//  BingoBarItemView.h
//
//  Created by WangBo on 2017/5/3.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;
#import "BingoBarItem.h"

@interface BingoBarItemView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)viewWithType:(BingoBarItemType)type
                     content:(id)content;

- (void)setupTarget:(id)target action:(SEL)action;

@property (assign, readonly, nonatomic) BingoBarItemType type;
@property (assign, nonatomic) BingoBadgeStyle badgeStyle;
@property (assign, nonatomic) NSInteger badge;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIView *contentPancel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *redDotView;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end
