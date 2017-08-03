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
    unit.priceStr = [NSString stringWithFormat:@"%.2f",price];
    unit.timestamp = [unit.date timeIntervalSince1970];
    return unit;
}

+ (NSArray<SPPriceUnit *> *)unitsWithDatas:(NSArray<NSArray *> *)datas
{
    if (!datas || ![datas isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *units = [NSMutableArray array];
    for (NSArray *aData in datas) {
        SPPriceUnit *aUnit = [SPPriceUnit unitWithData:aData];
        if (aUnit) {
            [units addObject:aUnit];
        }
    }
    return units;
}

- (NSString *)year_month_day
{
    return [NSString stringWithFormat:@"%d-%02d-%02d",self.date.year,self.date.month,self.date.day];
}

- (NSString *)month_day
{
    return [NSString stringWithFormat:@"%02d-%02d",self.date.month,self.date.day];
}

- (NSString *)unitDesc
{
    return [NSString stringWithFormat:@"%d-%02d-%02d 售出%d件",self.date.year,self.date.month,self.date.day,self.count];
}

@end
