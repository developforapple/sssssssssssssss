//
//  SPPriceUnit.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPriceUnit.h"
#import "YYModel.h"

NSDate * dateFromDateStr(NSString *str){
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateFormat = @"MMM dd yyyy HH: zz";
        formatter.monthSymbols = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    });
    
    NSDate *date = [formatter dateFromString:str];
#if DEBUG_MODE
    NSCAssert(date, @"日期解析出错");
#endif
    return date;
}

@implementation SPPriceUnit

YYModelDefaultCode

+ (instancetype)unitWithData:(NSArray *)data
{
    if (!data || ![data isKindOfClass:[NSArray class]] || data.count != 3) return nil;

    NSString *dateStr = data.firstObject;
    float price = [data[1] floatValue];
    NSInteger count = [data.lastObject integerValue];
    
    SPPriceUnit *unit = [SPPriceUnit new];
    unit.dateStr = dateStr;
    unit.price = price;
    unit.count = count;
    unit.date = dateFromDateStr(dateStr);
    return unit;
}

+ (NSArray<SPPriceUnit *> *)unitsWithDatas:(NSArray<NSArray *> *)datas
{
    NSMutableArray *units = [NSMutableArray array];
    for (NSArray *aData in datas) {
        SPPriceUnit *aUnit = [SPPriceUnit unitWithData:aData];
        if (aUnit) {
            [units addObject:aUnit];
        }
    }
    return units;
}

@end
