//
//  DDTaskBenchmarkTest.m
//  CDT
//
//  Created by wwwbbat on 2017/7/3.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "DDTaskBenchmarkTest.h"
#import "ReactiveObjC.h"

#if DEBUG_MODE

YG_INLINE struct timeval getTime(){
    struct timeval t;gettimeofday(&t, NULL);return t;
}

YG_INLINE NSValue *t2V(struct timeval t){
    return [NSValue value:&t withObjCType:@encode(struct timeval)];
}

YG_INLINE struct timeval v2t(NSValue *v){
    struct timeval t;[v getValue:&t];return t;
}

YG_INLINE float t2t(struct timeval t0, struct timeval t1){
    return (t1.tv_sec - t0.tv_sec) * 1000 + (t1.tv_usec - t0.tv_usec) * 0.001f;
}

static void *kTaskObserveCtx = &kTaskObserveCtx;

@interface DDURLSessionTaskBenchmark : NSObject
{
    NSMutableDictionary<NSString *, NSValue *> *_times;
    NSMutableSet<NSURLSessionTask *> *_tasks;
}
@end

@implementation DDURLSessionTaskBenchmark

- (instancetype)init
{
    self = [super init];
    if (self) {
        _times = [NSMutableDictionary dictionary];
        _tasks = [NSMutableSet set];
    }
    return self;
}

- (void)remarkTaskBegin:(NSURLSessionTask *)task
{
    struct timeval t = getTime();
    NSValue *v = t2V(t);
    _times[task.taskDescription] = v;
    [_tasks addObject:task];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSURLSessionTask *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == kTaskObserveCtx) {
        switch (object.state) {
            case NSURLSessionTaskStateSuspended:
            case NSURLSessionTaskStateCanceling:
            case NSURLSessionTaskStateCompleted:{
                
                struct timeval t1 = getTime();
                
                NSValue *v = _times[object.taskDescription];
                if (!v) return;
                _times[object.taskDescription] = nil;
                
                struct timeval t0 = v2t(v);
                float ms = t2t(t0, t1);
                
                NSString *stateDesc;
                if (object.state == NSURLSessionTaskStateSuspended) {
                    stateDesc = @"暂停";
                }else if (object.state == NSURLSessionTaskStateCompleted){
                    stateDesc = @"完成";
                }else if (object.state == NSURLSessionTaskStateCanceling){
                    stateDesc = @"取消";
                }
                
                NSLog(@"%@ %@ 耗时 %.1f ms",object.currentRequest.URL,stateDesc,ms);
                
                @try {
                    [object removeObserver:self forKeyPath:@"state"];
                    [_tasks removeObject:object];
                } @catch (NSException *exception) {
                    
                }
                
            }   break;
            case NSURLSessionTaskStateRunning:break;
        }
    }
}

@end

@implementation DDTaskBenchmarkTest

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return NO;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
{
    NSURL *url = task.originalRequest.URL;
    if ([url.host isEqualToString:kAppHost] ||
        [url.host isEqualToString:kZMBHost]) {
        
        static DDURLSessionTaskBenchmark *benchmark;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            benchmark = [DDURLSessionTaskBenchmark new];
        });
        
        [benchmark remarkTaskBegin:task];
    }
    return NO;
}
@end

#endif
