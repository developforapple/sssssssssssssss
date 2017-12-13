//
//  SPUpdater.h
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInfoManager.h"
#import "SPUpdaterState.h"

@class NSTextView;

// 检查更新间隔 2小时一次
#define kUpdateDuration (2*60*60)
// 超时时间 5分钟
#define kTimeout (5*60)

@interface SPUpdater : NSObject

@property (strong) SPUpdaterState *state;

@property (strong, readonly, nonatomic) SPInfoManager *info;

+ (instancetype)updater;

// 启动
- (void)start;
// 关闭
- (void)stop;

// 是否正在更新
@property (assign, readonly, getter=isUpdating, nonatomic) BOOL updating;

- (void)setLogOutputTextView:(NSTextView *)textView;

@end
