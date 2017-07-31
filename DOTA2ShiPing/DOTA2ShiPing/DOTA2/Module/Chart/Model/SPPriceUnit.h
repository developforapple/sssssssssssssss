//
//  SPPriceUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPriceUnit : NSObject <NSCoding,NSCopying>

@property (copy, nonatomic) NSString *dateStr;             //Oct 15 2016 01: +0
@property (assign, nonatomic) float price;              //0.913
@property (assign, nonatomic) NSInteger count;          //2

@property (strong, nonatomic) NSDate *date;

+ (instancetype)unitWithData:(NSArray *)data;

+ (NSArray<SPPriceUnit *> *)unitsWithDatas:(NSArray<NSArray *> *)datas;

@end
