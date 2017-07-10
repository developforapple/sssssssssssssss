//
//  NSObject+URLSessionTask.m
//  CDT
//
//  Created by wwwbbat on 2017/6/21.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
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
