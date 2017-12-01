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

NSString *const kOLDProductID = @"com.itemofdota2.proversion";
NSString *const kIAPProductAD = @"advertising";
NSString *const kIAPProductCoke = @"coke";
NSString *const kIAPProductCoffee = @"coffee";

@implementation SPIAPHelper

+ (BOOL)isPurchased
{
    return
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kOLDProductID] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kAdMobAppID] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoke] ||
    [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:kIAPProductCoffee];
    
}

// 重写此方法。保存凭据到客户端
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [SPIAPObject saveTransaction:transaction];
}

@end
