//
//  SPIAPHelper.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPIAPHelper.h"
#import "SPIAPObject.h"
#import "SPDeploy.h"
@import IAPHelper;
@import AVOSCloud;

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

- (BOOL)production
{
    BOOL p = [SPDeploy instance].deploy == YGAppDeployProduction;
    SPLog(@"当前为%@环境",p?@"生产":@"开发");
    return p;
}

+ (instancetype)getIAP
{
    static dispatch_semaphore_t semaphore ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    SPIAPHelper *helper = (SPIAPHelper *)[IAPShare sharedHelper].iap;
    if (!helper || ![helper isKindOfClass:[SPIAPHelper class]]){
        NSMutableSet *set = [NSMutableSet set];
        kIAPProductAD       ? [set addObject:kIAPProductAD]     : 0;
        kIAPProductCoke     ? [set addObject:kIAPProductCoke]   : 0;
        kIAPProductCoffee   ? [set addObject:kIAPProductCoffee] : 0;
        helper = [[SPIAPHelper alloc] initWithProductIdentifiers:set];
        [IAPShare sharedHelper].iap = helper;
    }
    dispatch_semaphore_signal(semaphore);
    return helper;
}

+ (BOOL)isPurchased
{
#if TARGET_PRO
    return YES;
#else
    return
    [SPIAP isPurchasedProductsIdentifier:kOLDProductID] ||
    [SPIAP isPurchasedProductsIdentifier:kIAPProductAD] ||
//    [SPIAP isPurchasedProductsIdentifier:kIAPProductCoke] || //购买可乐不再去除广告
    [SPIAP isPurchasedProductsIdentifier:kIAPProductCoffee];
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
