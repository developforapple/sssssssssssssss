//
//  SPItemTitleView.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPItemSharedData;

@interface SPItemTitleView : UIView
@property (strong, nonatomic) SPItemSharedData *itemData;
@end

@interface SPItemTag : NSObject
@property (copy, nonatomic) NSString *tag;
@property (strong, nonatomic) UIColor *color;
+ (instancetype)tag:(NSString *)tag color:(UIColor *)color;
@end

UIKIT_EXTERN NSString *const kSPItemTagCell;

@interface SPItemTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) SPItemTag *tagInfo;
@end
