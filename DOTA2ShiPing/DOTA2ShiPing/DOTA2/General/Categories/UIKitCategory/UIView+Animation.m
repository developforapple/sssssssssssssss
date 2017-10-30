//
//  UIView+Animation.m
//  Golf
//
//  Created by bo wang on 16/6/28.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "UIView+Animation.h"

dispatch_semaphore_t _UIViewAnimationSempahore(UIView *view){
    static const void *sempahoreKey = &sempahoreKey;
    dispatch_semaphore_t sempahore = objc_getAssociatedObject(view, sempahoreKey);
    if (!sempahore) {
        sempahore = dispatch_semaphore_create(1);
        objc_setAssociatedObject(view, sempahoreKey, sempahore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return sempahore;
}
#define UIViewAnimationSempahore(view) (_UIViewAnimationSempahore(view))

@implementation UIView (Animation)

- (dispatch_queue_t)sempahoreQueue
{
    static const void *queueKey = &queueKey;
    dispatch_queue_t q = objc_getAssociatedObject(self, queueKey);
    if (!q) {
        q = dispatch_queue_create("YGUIViewHiddenQueue", DISPATCH_QUEUE_CONCURRENT);
        objc_setAssociatedObject(self, queueKey, q, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return q;
}


- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self setHidden:hidden animated:animated completion:nil];
}

- (void)setHidden:(BOOL)hidden
         animated:(BOOL)animated
       completion:(void(^)(void))completion
{
    if (!animated){
        self.hidden = hidden;
        if (completion){
            completion();
        }
        return;
    }
    
    dispatch_async([self sempahoreQueue], ^{
        dispatch_semaphore_wait(UIViewAnimationSempahore(self), DISPATCH_TIME_FOREVER);
        RunOnMainQueue(^{
            [self executeSetter:hidden completion:completion];
        });
    });
}

- (void)executeSetter:(BOOL)hidden completion:(void(^)(void))completion
{
    if (self.hidden == hidden) {
        if (completion) completion();
        dispatch_semaphore_signal(UIViewAnimationSempahore(self));
        return;
    }
    if (hidden) {
        CGFloat alpha = self.alpha;
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = alpha;
            if (completion) completion();
            dispatch_semaphore_signal(UIViewAnimationSempahore(self));
        }];
    }else{
        CGFloat alpha = self.alpha;
        self.alpha = 0;
        self.hidden = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = alpha;
        } completion:^(BOOL finished) {
            if (completion) completion();
            dispatch_semaphore_signal(UIViewAnimationSempahore(self));
        }];
    }
}

@end
