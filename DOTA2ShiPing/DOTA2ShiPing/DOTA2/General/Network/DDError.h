//
//  DDError.h
//
//  Created by WangBo (developforapple@163.com) on 2017/4/1.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import Foundation;

@interface DDError : NSObject
@property (assign, nonatomic) NSInteger errcode;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) NSError *error;

+ (instancetype)error:(NSError *)err;
+ (instancetype)dataError:(id)response;

@end
