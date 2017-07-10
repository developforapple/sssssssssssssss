//
//  CDTAlertAction.m
//  CDT
//
//  Created by wwwbbat on 2017/5/12.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "CDTAlertAction.h"

@implementation CDTAlertAction

+ (instancetype)action:(NSString *)title handler:(void (^)(void))handler
{
    CDTAlertAction *action = [CDTAlertAction new];
    action.title = title;
    action.actionHandler = [handler copy];
    return action;
}

+ (instancetype)cancelAction
{
    return [self action:@"取消" handler:nil];
}

+ (instancetype)doneAction
{
    return [self action:@"确定" handler:nil];
}

@end
