//
//  NSObject+URLSessionTask.h
//  CDT
//
//  Created by wwwbbat on 2017/6/21.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;

@interface NSObject (URLSessionTask)
- (BOOL)task_isRunning;
- (BOOL)task_isCanceled;
- (BOOL)task_isFinished;
@end
