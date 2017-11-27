//
//  CDTAlertAction.h
//  CDT
//
//  Created by wwwbbat on 2017/5/12.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;

@interface CDTAlertAction : SPObject

+ (instancetype)action:(NSString *)title handler:(void (^)(void))handler;

+ (instancetype)cancelAction;
+ (instancetype)doneAction;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) void (^actionHandler)(void);

@end
