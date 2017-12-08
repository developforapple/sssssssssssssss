//
//  SPLogHelper.h
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSTextView;

FOUNDATION_EXPORT void SPLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2) NS_NO_TAIL_CALL;

@interface SPLogHelper : NSObject

+ (instancetype)helper;
- (void)log:(NSString *)text;

+ (void)setLogOutputTextView:(NSTextView *)textView;

@end
