//
//  DDSegmentScrollView.h
//  JuYouQu
//
//  Created by appleDeveloper on 15/12/17.
//  Copyright © 2015年 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSegmentScrollView : UIControl

// 正常字体大小 默认 14
@property (strong, nonatomic) UIFont *normalFont;
// 正常字体颜色 默认 灰色
@property (strong, nonatomic) UIColor *normalColor;
// 默认 黑色
@property (strong, nonatomic) UIColor *highlightColor;
// 高亮时的放大比例。默认 1.2
@property (assign, nonatomic) CGFloat highlightScale;

@property (assign, readonly, nonatomic) NSUInteger lastIndex;

@property (assign, nonatomic) NSUInteger currentIndex;

@property (strong, nonatomic) NSArray <NSString *>*titles;

@end
