//
//  SPIAPHelper.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <IAPHelper/IAPHelper.h>

YG_EXTERN NSString *const kSPPurchaseUpdateNotification;

YG_EXTERN NSString *const kOLDProductID;
YG_EXTERN NSString *const kIAPProductAD;
YG_EXTERN NSString *const kIAPProductCoke;
YG_EXTERN NSString *const kIAPProductCoffee;

@interface SPIAPHelper : IAPHelper

+ (BOOL)isPurchased;

+ (void)sendNotification;

@end
