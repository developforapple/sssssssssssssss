//
//  NSObject+URLSessionTask.h
//  CDT
//
//  Created by WangBo (developforapple@163.com) on 2017/6/21.
//  Copyright © 2017年 来电科技 All rights reserved.
//

@import Foundation;

@interface NSObject (URLSessionTask)
- (BOOL)task_isRunning;
- (BOOL)task_isCanceled;
- (BOOL)task_isFinished;
@end
