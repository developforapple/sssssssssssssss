//
//  Add.m
//  YYWebImageDemo
//
//  Created by bo wang on 16/7/21.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "YYWebImage+Add.h"
#import <objc/runtime.h>

#define DDSwizzleMethod +(void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector{Method originalMethod = class_getInstanceMethod(self, originalSelector);Method newMethod = class_getInstanceMethod(self, newSelector);BOOL methodAdded = class_addMethod([self class],originalSelector,method_getImplementation(newMethod),method_getTypeEncoding(newMethod));if (methodAdded){class_replaceMethod([self class],newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));}else{method_exchangeImplementations(originalMethod, newMethod);}}

@implementation YYWebImageOperation (Add)

DDSwizzleMethod

+ (void)load
{
    SEL oldSel = @selector(cancel);
    SEL newSel = @selector(add_cancel);
    [self swizzleInstanceSelector:oldSel withNewSelector:newSel];
}

- (void)add_cancel
{
    if (self.options&YYWebImageOptionNotBeCanceled) {
        [self setupOptions:self.options progress:nil transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {}];
    }else{
        [self add_cancel];
    }
}

- (void)setupOptions:(YYWebImageOptions)options
            progress:(YYWebImageProgressBlock)progress
           transform:(YYWebImageTransformBlock)transform
          completion:(YYWebImageCompletionBlock)completion
{
    @try {
        [self setValue:@(options) forKey:@"options"];
        [self setValue:progress forKey:@"progress"];
        [self setValue:transform forKey:@"transform"];
        [self setValue:completion forKey:@"completion"];
    } @catch (NSException *exception) {
    }
}
@end

@implementation YYWebImageManager (Add)

DDSwizzleMethod

+ (void)load
{
    SEL oldSel = @selector(requestImageWithURL:options:progress:transform:completion:);
    SEL newSel = @selector(add_requestImageWithURL:options:progress:transform:completion:);
    [self swizzleInstanceSelector:oldSel withNewSelector:newSel];
}

- (YYWebImageOperation *)add_requestImageWithURL:(NSURL *)url options:(YYWebImageOptions)options progress:(YYWebImageProgressBlock)progress transform:(YYWebImageTransformBlock)transform completion:(YYWebImageCompletionBlock)completion
{
    YYWebImageOperation *operationExist = [self existedOperationInQueue:url];
    if (operationExist && operationExist.isExecuting) {
        [operationExist setupOptions:options progress:progress transform:transform completion:completion];
        NSLog(@"%@ 任务已存在",url);
        return operationExist;
    }
    NSLog(@"启动下载：%@",url);
    return [self add_requestImageWithURL:url options:options progress:progress transform:transform completion:completion];
}

- (YYWebImageOperation *)existedOperationInQueue:(NSURL *)url
{
    if (!url) return nil;
    NSLog(@"队列里有%lu个任务",self.queue.operations.count);
    for (YYWebImageOperation *operation in self.queue.operations) {
        if ([operation.request.URL.absoluteString isEqualToString:url.absoluteString]) {
#if DEBUG
            NSString *state = operation.isExecuting?@"正在执行":(operation.isCancelled?@"被取消":@"其他");
            NSLog(@"找到任务 状态：%@",state);
#endif
            return operation;
        }
    }
    return nil;
}



@end
