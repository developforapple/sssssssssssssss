//
//  SPPriceChartConfig.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/8/3.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPriceChartConfig.h"

@implementation SPPriceChartConfig
@end

// number of ticks, use this.
CGFloat bestInterval(CGFloat range,CGFloat numberTicks) {
    
    CGFloat minimum = range / (numberTicks - 1);
    CGFloat magnitude = pow(10, floor(log(minimum) / M_LN10));
    CGFloat residual = minimum / magnitude;
    CGFloat interval;
    // "nicest" ranges are 1, 2, 5 or powers of these.
    // for magnitudes below 1, only allow these.
    if (magnitude < 1) {
        if (residual > 5) {
            interval = 10 * magnitude;
        }
        else if (residual > 2) {
            interval = 5 * magnitude;
        }
        else if (residual > 1) {
            interval = 2 * magnitude;
        }
        else {
            interval = magnitude;
        }
    }
    // for large ranges (whole integers), allow intervals like 3, 4 or powers of these.
    // this helps a lot with poor choices for number of ticks.
    else {
        if (residual > 5) {
            interval = 10 * magnitude;
        }
        else if (residual > 4) {
            interval = 5 * magnitude;
        }
        else if (residual > 3) {
            interval = 4 * magnitude;
        }
        else if (residual > 2) {
            interval = 3 * magnitude;
        }
        else if (residual > 1) {
            interval = 2 * magnitude;
        }
        else {
            interval = magnitude;
        }
    }
    return interval;
}




CGFloat bestLinearInterval(CGFloat range, CGFloat scalefact) {
    //    scalefact = scalefact || 1;
    CGFloat expv = floor(log(range)/M_LN10);
    CGFloat magnitude = pow(10, expv);
    // 0 < f < 10
    CGFloat f = range / magnitude;
    CGFloat fact;
    f = f/scalefact;
    
    if (f<=0.38) {
        fact = 0.1;
    }
    else if (f<=1.6) {
        fact = 0.2;
    }
    else if (f<=4.0) {
        fact = 0.5;
    }
    else if (f<=8.0) {
        fact = 1.0;
    }
    else if (f<=16.0) {
        fact = 2;
    }
    else {
        fact = 5;
    }
    return fact*magnitude;
}


// returned is an array containing [min, max, nTicks, format]
SPPriceChartConfig *LinearTickGenerator(CGFloat axis_min,CGFloat axis_max,CGFloat scalefact,CGFloat numberTicks) {
    
    
    if (axis_min == axis_max) {
        axis_max = (axis_max) ? 0 : 1;
    }
    
    // make sure range is positive
    if (axis_max < axis_min) {
        CGFloat a = axis_max;
        axis_max = axis_min;
        axis_min = a;
    }
    
    SPPriceChartConfig *config = [SPPriceChartConfig new];
    
    
    CGFloat ss = bestLinearInterval(axis_max - axis_min, scalefact);
    
    {
        CGFloat _min = floor(axis_min / ss) * ss;
        CGFloat _max = ceil(axis_max / ss) * ss;
        CGFloat _numberOfTicks = round((_max-_min)/ss+1.0);
        CGFloat _tickInterval = ss;
        
        // first, see if we happen to get the right number of ticks
        if (_numberOfTicks == numberTicks) {
            
            config.bottomPrice = _min;
            config.topPrice = _max;
            config.rows = _numberOfTicks;
            config.interval = _tickInterval;
            
        }else {
            
            CGFloat newti = bestInterval( _max-_min, numberTicks);
            
            config.bottomPrice = _min;
            config.topPrice = _min + (numberTicks-1) * newti;
            config.rows = numberTicks;
            config.interval = newti;
        }
    }
    
    return config;
};
