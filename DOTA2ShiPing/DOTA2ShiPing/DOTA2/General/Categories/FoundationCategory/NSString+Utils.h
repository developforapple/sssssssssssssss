//
//  NSString+Utils.h
//  QuizUp
//
//  Created by Normal on 16/4/8.
//  Copyright © 2016年 zhenailab. All rights reserved.
//

@import Foundation;

@interface NSString (Utils)

+ (NSRange)rangeOfURL:(NSString *)string;

+ (NSAttributedString *)attributedStringByAddUnderlineForURLInString:(NSString *)string;

// 查找出现的整数
- (NSArray<NSNumber *> *)scannerIntergers:(NSInteger)count;
- (NSArray<NSNumber *> *)scannerAllIntergers;

// 查找出现的正整数。忽略'-' 例如 -100 会被当做 100 返回
- (NSArray<NSNumber *> *)scannerUIntergers:(NSInteger)count;
- (NSArray<NSNumber *> *)scannerAllUIntergers;

@end
