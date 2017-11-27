//
//  SPDota2MarketItem.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@interface SPDota2MarketItem : SPObject <NSCopying,NSCoding>

@property (copy, nonatomic) NSString *discountTagBase;
@property (copy, nonatomic) NSString *discountedPrice;
@property (copy, nonatomic) NSString *itemImageDropShadow;
@property (copy, nonatomic) NSString *itemNameBase;
@property (copy, nonatomic) NSString *originalPrice;
@property (copy, nonatomic) NSString *playerClass;
@property (assign, nonatomic) long long remainingTime;
@property (assign, nonatomic) long long updateTime;

+ (instancetype)curItem;

+ (BOOL)needUpdate;
- (void)save;


@end
