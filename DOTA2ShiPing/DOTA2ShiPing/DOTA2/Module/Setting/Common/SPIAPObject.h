//
//  SPIAPObject.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
@import StoreKit;

@interface SPIAPObject : AVObject

+ (void)saveTransaction:(SKPaymentTransaction *)transaction;
+ (void)saveTransaction:(SKPaymentTransaction *)transaction verification:(NSString *)response;

@end
