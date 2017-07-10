//
//  YGRemoteNotificationHelper.h
//  Golf
//
//  Created by bo wang on 2016/9/26.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, YGNotificaitonType) {
    YGNotificaitonTypeNone = 0,
    YGNotificaitonTypeBadge = 1 << 0,
    YGNotificaitonTypeSound = 1 << 1,
    YGNotificaitonTypeAlert = 1 << 2,
};
#define YGNotificationTypeAll (YGNotificaitonTypeBadge | YGNotificaitonTypeSound | YGNotificaitonTypeAlert)

// 在前台收到远程通知时的样式
typedef NS_ENUM(NSUInteger, YGNotificaitonForegroundStyle) {
    YGNotificaitonForegroundStyleIgnore,      //不提示 不响应
    YGNotificaitonForegroundStyleNoAlert,     //不提示 直接响应
    YGNotificaitonForegroundStyleDefault,     //默认提示 用户决定是否响应
    YGNotificaitonForegroundStyleCustom,      //自定义提示 用户决定是否响应
};

@class YGRemoteNotificationHelper;

@protocol YGRemoteNotificationHelperDelegate <NSObject>
@required
// 收到deviceToken时的回调
- (void)notificationHelper:(YGRemoteNotificationHelper *)helper didReceivedDeviceToken:(NSString *)str;
// 收到远程通知时的回调
- (void)notificationHelper:(YGRemoteNotificationHelper *)helper didReceivedRemoteNotification:(NSDictionary *)userInfo;
@optional
// 收到本地通知时的回调
- (void)notificationHelper:(YGRemoteNotificationHelper *)helper didReceivedLocalNotification:(UILocalNotification *)notification;

// 当应用处在前台时，收到远程通知回调之前先确定是否提示用户。如果选择提示用户，并且用户响应了提示内容。才算真正收到了远程通知
- (YGNotificaitonForegroundStyle)notificationHelper:(YGRemoteNotificationHelper *)helper styleInForeground:(NSDictionary *)userInfo;
// 当应用处在前台时，收到远程通知前提示用户。用户对提示的响应。
- (void)notificationHelper:(YGRemoteNotificationHelper *)helper willAlertUseCustomStyle:(NSDictionary *)userInfo;

@end

// 兼容iOS7~iOS10的远程通知单例
@interface YGRemoteNotificationHelper : NSObject

+ (instancetype)shared;

@property (weak, nonatomic) id<YGRemoteNotificationHelperDelegate> delegate;

// 需要在 applicationDidFinishLaunching: 返回之前做一些设置
- (void)setup:(nullable NSDictionary *)launchOptions;

// 当提示用户的方式是 YGNotificaitonAlertStyleCustom 时，用户操作提示后应当调用此方法。
- (void)responseRemoteNotification:(NSDictionary *)userInfo isCanceled:(BOOL)isCanceled;

@property (strong, nullable, readonly, nonatomic) NSData *deviceToken;
@property (strong, nullable, readonly, nonatomic) NSString *deviceTokenStr;
@property (strong, nullable, readonly, nonatomic) NSError *error;

#pragma mark - APNS
// 向APNS注册远程通知，获取DeviceToken。在iOS7下，获取deviceToken将会在registerNotificationType中进行。
- (void)registerRemoteNotificaitons;
// 向APNS取消注册远程通知
- (void)unregisterRemoteNotifications;
// APNS返回了deviceToken或者失败时调用
- (void)didReceiveDeviceToken:(nullable NSData *)data orError:(nullable NSError *)error;
// 是否已向APNS注册了远程通知
- (BOOL)isRegisteredForRemoteNotifications;

#pragma mark - Settings
// 设置应用Icon的角标数字。0为隐藏。在iOS8以后需要注册settings来修改数字
- (void)setIconBadgeNumber:(NSUInteger)number;
// 注册通知类型。如果没有向APNS注册过，将自动向APNS注册。
- (void)registerNotificationType:(YGNotificaitonType)type;
// 单种通知类型是否可用。如果未注册过或者未取得权限，返回不可用。iOS10之前block同步调用，iOS10及以后block异步调用
- (void)isNotificationTypeEnabled:(YGNotificaitonType)type completion:(void(^)(BOOL enabled))completion;

#pragma mark - Notification
// 接收到远程通知
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end

@interface CDTAppDelegate (YGNotification)
@end

NS_ASSUME_NONNULL_END
