//
//  Inline.h
//
//  Created by bo wang on 2017/4/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Inline_h
#define Inline_h

#define ALWAYS_INLINE YG_INLINE

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

ALWAYS_INLINE
void
RunAfter(NSTimeInterval time,dispatch_block_t x){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)), dispatch_get_main_queue(), x);
}


#endif /* Inline_h */
