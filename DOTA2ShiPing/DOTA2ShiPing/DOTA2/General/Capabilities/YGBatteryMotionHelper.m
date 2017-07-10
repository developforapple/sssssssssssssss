//
//  YGBatteryMotionHelper.m
//  CDT
//
//  Created by wwwbbat on 2017/5/15.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "YGBatteryMotionHelper.h"

@interface YGBatteryMotionHelper ()
@property (assign, readwrite, nonatomic) BOOL monitoring;
@property (assign, readwrite, nonatomic) float level;
@property (assign, readwrite, nonatomic) UIDeviceBatteryState state;
@property (assign, readwrite, nonatomic) BOOL lowPowerMode;
@property (copy, nonatomic) YGBatteryInfoChangedHandler handler;
@end

@implementation YGBatteryMotionHelper

+ (instancetype)helper
{
    static YGBatteryMotionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [YGBatteryMotionHelper new];
        helper.state = UIDeviceBatteryStateUnknown;
        helper.level = -1;
    });
    return helper;
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelDidChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateDidChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    if (iOS9) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lowPowerModeDidChanged:) name:NSProcessInfoPowerStateDidChangeNotification object:nil];
    }
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startMonitor
{
    if (!self.monitoring) {
        self.monitoring = YES;
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        [self registerNotifications];
    }
}

- (void)endMonitor
{
    if (self.monitoring) {
        self.monitoring = NO;
        [UIDevice currentDevice].batteryMonitoringEnabled = NO;
        [self removeNotifications];
    }
}

- (void)batteryLevelDidChanged:(__unused NSNotification *)noti
{
    if (!self.monitoring) return;
    [self updateInfo];
}

- (void)batteryStateDidChanged:(__unused NSNotification *)noti
{
    if (!self.monitoring) return;
    [self updateInfo];
}

- (void)lowPowerModeDidChanged:(__unused NSNotification *)noti
{
    if (!self.monitoring) return;
    [self updateInfo];
}

- (void)setObserveHandler:(YGBatteryInfoChangedHandler)handler
{
    self.handler = handler;
}

- (void)updateInfo
{
    self.level = [UIDevice currentDevice].batteryLevel;
    self.state = [UIDevice currentDevice].batteryState;
    if (iOS9) {
        self.lowPowerMode = [[NSProcessInfo processInfo] isLowPowerModeEnabled];
    }
    [self callHandler];
}

- (void)callHandler
{
    if (self.handler) {
        self.handler(self.level, self.state, self.lowPowerMode);
    }
}

@end
