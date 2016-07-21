//
//  Add.h
//  YYWebImageDemo
//
//  Created by bo wang on 16/7/21.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "YYWebImage.h"

typedef NS_OPTIONS(NSUInteger, YYWebImageOptionsAdd) {
    YYWebImageOptionNotBeCanceled = YYWebImageOptionIgnoreFailedURL << 5,//多留几个位置
};

@interface YYWebImageOperation (Add)

// 重新设置选项和回调
- (void)setupOptions:(YYWebImageOptions)options
            progress:(nullable YYWebImageProgressBlock)progress
           transform:(nullable YYWebImageTransformBlock)transform
          completion:(nullable YYWebImageCompletionBlock)completion;
@end


@interface YYWebImageManager (Add)
@end