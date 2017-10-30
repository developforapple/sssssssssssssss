//
//  DDResponse.h
//
//  Created by WangBo (developforapple@163.com) on 2017/4/1.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import Foundation;
#import "DDError.h"

// 非DDRespResultSuc都是失败
typedef NS_ENUM(NSInteger, DDRespResult) {
    DDRespResultSuc = 1,
    DDRespResultFail = -1,
    DDRespResultLogout = -2,
    
    DDRespResultNetworkErr = NSIntegerMax, // 网络连接错误
};

@interface DDResponse : NSObject

#pragma mark - 原始数据
/**
 响应结果code
 */
@property (assign, nonatomic) DDRespResult result;
/**
 数据id
 */
@property (assign, nonatomic) NSInteger id;
/**
 服务器响应数据中message内容。或者错误信息。
 */
@property (copy, nonatomic) NSString *msg;
/**
 服务器响应数据
 */
@property (strong, nonatomic) NSDictionary *data;
/**
 数据排序id
 */
@property (copy, nonatomic) NSNumber *sortTime;

#pragma mark - 额外数据
/**
 服务器响应状态码
 */
@property (assign, nonatomic) NSInteger statusCode;

/**
 响应是否有效。出现错误时为NO。没有错误，服务器返回result为fail时也为NO。其余为YES。
 */
@property (assign, nonatomic) BOOL suc;

/**
 当出现网络问题或者数据解析问题时，AF返回的错误信息。
 */
@property (strong, readonly, nonatomic) DDError *error;

+ (instancetype)response:(NSURLResponse *)response object:(NSDictionary *)object;
+ (instancetype)response:(NSURLResponse *)response error:(NSError *)error;

- (BOOL)networkError;

@end
