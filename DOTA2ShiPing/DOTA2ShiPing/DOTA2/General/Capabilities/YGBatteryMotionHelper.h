//
//  YGBatteryMotionHelper.h
//  CDT
//
//  Created by wwwbbat on 2017/5/15.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;

typedef void(^YGBatteryInfoChangedHandler)(float level, UIDeviceBatteryState state, BOOL lowPowerMode);

@interface YGBatteryMotionHelper : NSObject

+ (instancetype)helper;

@property (assign, readonly, nonatomic) BOOL monitoring;
@property (assign, readonly, nonatomic) float level;
@property (assign, readonly, nonatomic) UIDeviceBatteryState state;

// 9.0开始支持低电量模式
@property (assign, readonly, nonatomic) BOOL lowPowerMode;

- (void)startMonitor;
- (void)endMonitor;

- (void)setObserveHandler:(YGBatteryInfoChangedHandler)handler;

@end
