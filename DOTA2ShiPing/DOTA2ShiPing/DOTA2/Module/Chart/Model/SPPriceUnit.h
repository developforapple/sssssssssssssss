//
//  SPPriceUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPriceUnit : NSObject <NSCoding,NSCopying>

@property (copy, nonatomic) NSString *dateStr;          //Oct 15 2016 01: +0
@property (assign, nonatomic) float price;              //0.913
@property (assign, nonatomic) NSInteger count;          //2
@property (copy, nonatomic) NSString *prefix;           // $
@property (copy, nonatomic) NSString *currency;         //USD
@property (copy, nonatomic) NSString *priceStr;         //0.913

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) NSTimeInterval timestamp;

+ (instancetype)unitWithData:(NSArray *)data;

+ (NSArray<SPPriceUnit *> *)unitsWithDatas:(NSArray<NSArray *> *)datas;

- (NSString *)year_month_day;
- (NSString *)month_day;
- (NSString *)unitDesc;

@end
