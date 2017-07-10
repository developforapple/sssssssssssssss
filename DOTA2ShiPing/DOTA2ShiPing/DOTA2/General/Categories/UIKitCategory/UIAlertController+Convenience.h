//
//  UIAlertController+Convenience.h
//
//  Created by bo wang on 2017/4/21.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface UIAlertController (Convenience)

#if DEBUG_MODE
/**
 显示一段debug消息。release不会出现

 @param message 消息内容
 */
+ (void)showDebugMessage:(NSString *)message;

#endif

/**
 弹出提示框，标题+内容+确认按钮

 @param title 标题
 @param message 内容
 @return instance
 */
+ (instancetype)alert:(NSString *)title
              message:(NSString *)message;

/**
 弹出提示框，标题+内容+确认按钮

 @param title 标题
 @param message 内容
 @param callback 确认回调
 @return instance
 */
+ (instancetype)alert:(NSString *)title
              message:(NSString *)message
             callback:(void(^)(void))callback;

/**
 弹出确认提示，标题+取消+确认

 @param title 标题
 @param callback 确认回调
 @return instance
 */
+ (instancetype)confirm:(NSString *)title
               callback:(void(^)(BOOL))callback;

/**
 弹出确认提示，标题+内容+取消+确认

 @param title 标题
 @param message 内容
 @param callback 确认回调
 @return instance
 */
+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
               callback:(void(^)(BOOL))callback;

/**
 弹出确认提示，标题+内容+取消，自定义确认按钮

 @param title 标题
 @param message 内容
 @param done 确认按钮标题
 @param callback 确认回调
 @return instance
 */
+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                   done:(NSString *)done
               callback:(void(^)(BOOL))callback;

/**
 弹出确认提示，标题+内容，自定义确认按钮、取消按钮

 @param title 标题
 @param message 内容
 @param cancel 取消按钮标题
 @param done 确认按钮标题
 @param callback 确认回调
 @return instance
 */
+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                 cancel:(NSString *)cancel
                   done:(NSString *)done
               callback:(void(^)(BOOL isDone))callback;

+ (instancetype)confirm:(NSString *)title
                message:(NSString *)message
                 cancel:(NSString *)cancel
                redDone:(NSString *)done
               callback:(void(^)(BOOL isDone))callback;

@end
