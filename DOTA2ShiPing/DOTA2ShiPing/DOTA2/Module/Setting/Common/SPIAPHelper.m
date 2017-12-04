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

#if TARGET_PRO
// 付费版
NSString *const kOLDProductID       ;
NSString *const kIAPProductAD       ;
NSString *const kIAPProductCoke     = @"com.wwwbbat.sp.pro.coke";
NSString *const kIAPProductCoffee   = @"com.wwwbbat.sp.pro.coffee";
#elif TARGET_AD
// 免费广告版
NSString *const kOLDProductID       ;
NSString *const kIAPProductAD       = @"com.wwwbbat.sp.ad.remove";
NSString *const kIAPProductCoke     = @"com.wwwbbat.sp.ad.coke";
NSString *const kIAPProductCoffee   = @"com.wwwbbat.sp.ad.coffee";
#elif TARGET_OLD
// 旧版
NSString *const kOLDProductID       = @"com.itemofdota2.proversion";
NSString *const kIAPProductAD       = @"advertising";
NSString *const kIAPProductCoke     = @"coke";
NSString *const kIAPProductCoffee   = @"coffee";
#else
// 企业版
NSString *const kOLDProductID       ;
NSString *const kIAPProductAD       ;
NSString *const kIAPProductCoke     ;
NSString *const kIAPProductCoffee   ;
#endif

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
