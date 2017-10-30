//
//  NSObject+URLSessionTask.m
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/21.
//  Copyright © 2017年 来电科技 All rights reserved.
//

#import "NSObject+URLSessionTask.h"

@implementation NSObject (URLSessionTask)
- (BOOL)isNSURLSesstionTask
{
    return [self isKindOfClass:[NSURLSessionTask class]];
}

- (BOOL)task_isRunning
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateRunning;
    }
    return NO;
}

- (BOOL)task_isCanceled
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateCanceling;
    }
    return NO;
}

- (BOOL)task_isFinished
{
    if ([self isNSURLSesstionTask]) {
        NSURLSessionTask *task = (NSURLSessionTask *)self;
        return task.state == NSURLSessionTaskStateCompleted;
    }
    return NO;
}
@end
