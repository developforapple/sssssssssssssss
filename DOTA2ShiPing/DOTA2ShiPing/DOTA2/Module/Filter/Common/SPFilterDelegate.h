//
//  SPFilterDelegate.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPBaseFilter;
@class SPFilterUnit;

@protocol SPFilterDelegate <NSObject>


- (void)filter:(SPBaseFilter *)filter didCompleted:(NSArray<SPFilterUnit *> *)units;

@end
