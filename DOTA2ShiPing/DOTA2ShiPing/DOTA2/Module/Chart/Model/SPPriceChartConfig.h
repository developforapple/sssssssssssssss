//
//  SPPriceChartConfig.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/3.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SPPriceChartLevel) {
    SPPriceChartLevelWeek,  //周
    SPPriceChartLevelMonth, //月
    SPPriceChartLevelQuarter,//季
    SPPriceChartLevelYear,  //年
    SPPriceChartLevelAll,   //全部
};

YG_INLINE NSString *LevelString(SPPriceChartLevel level){
    switch (level) {
        case SPPriceChartLevelWeek:return @"周";break;
        case SPPriceChartLevelMonth:return @"月";break;
        case SPPriceChartLevelQuarter:return @"季";break;
        case SPPriceChartLevelYear:return @"年";break;
        case SPPriceChartLevelAll:return @"全部";break;
    }
    return nil;
}

@interface SPPriceChartConfig : NSObject
@property (assign, nonatomic) CGFloat topPrice;
@property (assign, nonatomic) CGFloat bottomPrice;
@property (assign, nonatomic) NSInteger rows;
@property (assign, nonatomic) CGFloat interval;
@end


YG_EXTERN CGFloat bestInterval(CGFloat range,CGFloat numberTicks);
YG_EXTERN CGFloat bestLinearInterval(CGFloat range, CGFloat scalefact);
YG_EXTERN SPPriceChartConfig *LinearTickGenerator(CGFloat axis_min,CGFloat axis_max,CGFloat scalefact,CGFloat numberTicks);
