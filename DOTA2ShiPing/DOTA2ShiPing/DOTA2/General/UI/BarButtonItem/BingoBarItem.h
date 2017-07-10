//
//  BingoBarItem.h
//
//  Created by WangBo on 2017/5/3.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, BingoBarItemType) {
    BingoBarItemTypeText = 0,     //默认，纯文本
    BingoBarItemTypeInternal = 1, //一些内置的icon
    BingoBarItemTypeImage = 2,    //图片,可以是URL或者本地图片
};

typedef NS_ENUM(NSUInteger, BingoBarItemInternalType) {
    BingoBarItemInternalType_
};

NS_INLINE BOOL isValidBarItemInternalType(BingoBarItemInternalType type){
    return NO;
}

typedef NS_ENUM(NSUInteger, BingoBadgeStyle) {
    BingoBadgeStyleRedDot,   //红点
    BingoBadgeStyleSystem,   //系统风格的，显示完整的数字。
    BingoBadgeStyleMax99,    //系统风格的，最多显示99，超过之后显示为99+
};

@interface BingoBarItem : UIBarButtonItem

@property (assign, readonly, nonatomic) BingoBarItemType type;
@property (assign, nonatomic) BingoBadgeStyle badgeStyle;
@property (assign, nonatomic) NSInteger badge;


// 自动隐藏badge。当item发生点击事件后，隐藏掉badge。默认为YES。
@property (assign, nonatomic) BOOL hideBadgeAuto;

/**
 创建barItem

 @param type 类型
 @param content item内容，根据type的不同支持不同的类型。
        text:NSString类型标题，
        Internal:NSNumber of BingoBarItemInternalType，
        Image: NSString图片链接，UIImage图片内容。
 @param target
 @param action
 @return
 */
- (instancetype)initWithType:(BingoBarItemType)type
                     content:(id)content
                      target:(id)target
                      action:(SEL)action;


+ (instancetype)itemWithType:(BingoBarItemType)type
                     content:(id)content
                      target:(id)target
                      action:(SEL)action;

@end
