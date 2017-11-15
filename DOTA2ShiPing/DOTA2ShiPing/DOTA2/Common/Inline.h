//
//  Inline.h
//
//  Created by bo wang on 2017/4/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Inline_h
#define Inline_h

NS_ASSUME_NONNULL_BEGIN

#ifdef YG_INLINE
    #define ALWAYS_INLINE YG_INLINE
#else
    define ALWAYS_INLINE static __inline__ __attribute__((always_inline))
#endif

#pragma mark - Thread
// 在主线程执行block
ALWAYS_INLINE
void
RunOnMainQueue(dispatch_block_t x){
    if ([NSThread isMainThread]){ if (x)x(); }else dispatch_async(dispatch_get_main_queue(),x);
}

ALWAYS_INLINE
void
RunOnGlobalQueue(dispatch_block_t x){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), x);
}

#pragma mark - Timer

ALWAYS_INLINE
void
RunAfter(NSTimeInterval time,dispatch_block_t x){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(), x);
}

ALWAYS_INLINE
__nullable dispatch_source_t
RunPeriodic(NSTimeInterval period,NSTimeInterval delay,dispatch_block_t x){
    if (period <= 0 || delay < 0 || !x) return nil;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, x);
    dispatch_resume(timer);
    return timer;
}

#pragma mark - Benchmark
//#import <sys/time.h>
extern int gettimeofday(struct timeval *, void * _Nullable);

ALWAYS_INLINE
double _benchmarkTimeDiff(struct timeval t0,struct timeval t1){
    return (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
}

#pragma mark Sync Benchmark

ALWAYS_INLINE
double SyncBenchmarkTest(void (^block)(void)){
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    return _benchmarkTimeDiff(t0, t1);
}

ALWAYS_INLINE
void SyncBenchmarkTestAndLog(void (^block)(void)){
    double ms = SyncBenchmarkTest(block);
    NSLog(@"Benchmark result: %.2f ms",ms);
}

ALWAYS_INLINE
void SyncBenchmarkTestV2(void (^block)(void), void (^complete)(double ms)){
    double ms = SyncBenchmarkTest(block);
    complete(ms);
}

#pragma mark Async Benchmark

ALWAYS_INLINE
struct timeval _AsyncBenchmarkTestBegin(){
    struct timeval t0;
    gettimeofday(&t0, NULL);
    return t0;
}

ALWAYS_INLINE
double _AsyncBenchmarkTestEnd(struct timeval begin){
    struct timeval t0 = begin;
    struct timeval t1;
    gettimeofday(&t1, NULL);
    return _benchmarkTimeDiff(t0, t1);
}

// Example：
// AsyncBenchmarkTestBegin(AnyTag)
// //do some thing async
// //on callback block:
// AsyncBenchmarkTestEnd(AnyTag)

#define AsyncBenchmarkTestBegin(TAG)     \
    NSLog(@"Benchmark Test Begin! Tag: %@",@#TAG);  \
    struct timeval __benchmarkTag_##TAG = _AsyncBenchmarkTestBegin();

#define AsyncBenchmarkTestEnd(TAG)       \
    double __benchmarkResult_##TAG = _AsyncBenchmarkTestEnd( __benchmarkTag_##TAG ) ;    \
    NSLog(@"Benchmark Test End! Tag: %@ Result:%.2f ms" , @#TAG , __benchmarkResult_##TAG );

NS_ASSUME_NONNULL_END

#endif /* Inline_h */

