//
//  UIAlertController+Convenience.m
//
//  Created by bo wang on 2017/4/21.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIAlertController+Convenience.h"

@implementation UIAlertController (Convenience)

+ (void)showDebugMessage:(NSString *)message
{
#if DEBUG_MODE
    [self alert:nil message:message];
#endif
}

+ (instancetype)alert:(NSString *)title
              message:(NSString *)message
{
    return [self alert:title message:message callback:nil];
}

+ (instancetype)alert:(NSString *)title
              message:(NSString *)message
             callback:(void(^)(void))callback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"SURE", @"确认") style:UIAlertActionStyleCancel handler:^(id a){
        if (callback) {
            callback();
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

+ (instancetype)confirm:(NSString *)title
               callback:(void(^)(BOOL))callback
{
    return [self confirm:title message:nil done:nil callback:callback];
}

+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
               callback:(void(^)(BOOL))callback
{
    return [self confirm:title message:message done:nil callback:callback];
}

+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                   done:(NSString *)done
               callback:(void(^)(BOOL))callback
{
    return [self confirm:title message:message cancel:nil done:done callback:callback];
}

+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                 cancel:(NSString *)cancel
                   done:(NSString *)done
               callback:(void(^)(BOOL))callback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel?:NSLocalizedString(@"CANCEL",@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (callback) {
            callback(NO);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:done?:NSLocalizedString(@"SURE",@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (callback) {
            callback(YES);
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                 cancel:(NSString *)cancel
                redDone:(NSString *)done
               callback:(void(^)(BOOL isDone))callback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel?:NSLocalizedString(@"CANCEL",@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (callback) {
            callback(NO);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:done?:NSLocalizedString(@"SURE",@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (callback) {
            callback(YES);
        }
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end
