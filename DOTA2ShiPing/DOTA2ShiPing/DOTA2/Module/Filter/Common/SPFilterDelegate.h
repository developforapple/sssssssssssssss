//
//  SPFilterDelegate.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class SPBaseFilter;
@class SPFilterUnit;

@protocol SPFilterDelegate <NSObject>


- (void)filter:(SPBaseFilter *)filter didCompleted:(NSArray<SPFilterUnit *> *)units;

@end
