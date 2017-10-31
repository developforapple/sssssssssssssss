//
//  SPItemSaleView.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/31.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPItemSharedData;

@interface SPItemSaleView : UIView
@property (strong, nonatomic) SPItemSharedData *itemData;
@end

@interface SPItemPlatform : NSObject
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *logo;
+ (instancetype)named:(NSString *)name logoNamed:(NSString *)logoName;
@end

UIKIT_EXTERN NSString *const kSPItemPlatformCell;

@interface SPItemPlatformCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) SPItemPlatform *platform;
@end
