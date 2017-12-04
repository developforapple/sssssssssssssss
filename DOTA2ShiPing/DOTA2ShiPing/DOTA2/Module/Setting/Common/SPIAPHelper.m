//
//  SPIAPHelper.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPHelper.h"
#import "SPIAPObject.h"
@import IAPHelper;

NSString *const kSPPurchaseUpdateNotification = @"SPPurchasedNotification";

NSString *const kOLDProductID = @"com.itemofdota2.proversion";
NSString *const kIAPProductAD = @"advertising";
NSString *const kIAPProductCoke = @"coke";
NSString *const kIAPProductCoffee = @"coffee";

@implementation SPIAPHelper

+ (BOOL)isPurchased
{
#if TARGET_PRO
    return YES;
#else
    return
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kOLDProductID] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductAD] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoke] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoffee];
#endif
}

+ (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSPPurchaseUpdateNotification object:nil];
}

// 重写此方法。保存凭据到客户端
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [SPIAPObject saveTransaction:transaction];
}

@end
