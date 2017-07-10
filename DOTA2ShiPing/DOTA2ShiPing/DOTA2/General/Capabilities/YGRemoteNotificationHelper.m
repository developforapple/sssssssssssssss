//
//  YGRemoteNotificationHelper.m
//  Golf
//
//  Created by bo wang on 2016/9/26.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "YGRemoteNotificationHelper.h"

@import UserNotifications;

NO_WARNING_BEGIN(-Wdeprecated-declarations)
NO_WARNING_BEGIN(-Wunused-function)

#define UNCenter [UNUserNotificationCenter currentNotificationCenter]

NS_INLINE UNAuthorizationOptions type_iOS10_And_Later(YGNotificaitonType type){
    return (UNAuthorizationOptions)type;
}

NS_INLINE UIUserNotificationType type_iOS8_And_iOS9(YGNotificaitonType type){
    return (UIUserNotificationType)type;
}

NS_INLINE UIRemoteNotificationType type_iOS7_And_Earlier(YGNotificaitonType type){
    return (UIRemoteNotificationType)type;
}

NO_WARNING_END

static NSInteger YGNotificationAlertViewTag = 10000;

@interface _YGAlertView : UIAlertView
@property (strong, nonatomic) NSDictionary *userInfo;
@end
@implementation _YGAlertView
@end

@interface YGRemoteNotificationHelper () <UIAlertViewDelegate>
{
    BOOL _registerRemoteNotificaitonsFlag;
}
@property (strong, readwrite, nonatomic) NSData *deviceToken;
@property (strong, readwrite, nonatomic) NSString *deviceTokenStr;
@property (strong, readwrite, nonatomic) NSError *error;
@end


NO_WARNING_BEGIN(-Wunguarded-availability)
@interface YGRemoteNotificationHelper (UNUserNotificationCenterSupport)<UNUserNotificationCenterDelegate>
@end
NO_WARNING_END

@implementation YGRemoteNotificationHelper

+ (instancetype)shared
{
    static YGRemoteNotificationHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YGRemoteNotificationHelper new];
    });
    return instance;
}

- (void)setup:(NSDictionary *)launchOptions
{
    if (iOS10) {
        [UNCenter setDelegate:self];
    }
    
    if (launchOptions) {
        NSDictionary *remoteInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        UILocalNotification *localInfo = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        
        if (remoteInfo) {
            [self didReceiveRemoteNotification:remoteInfo];
        }
        if (localInfo) {
            [self didReceiveLocalNotification:localInfo];
        }
    }
}

- (void)responseRemoteNotification:(NSDictionary *)userInfo isCanceled:(BOOL)isCanceled
{
    if (!isCanceled) {
        [[YGRemoteNotificationHelper shared] didReceiveRemoteNotification:userInfo];
    }
}

#pragma mark - APNS
- (void)registerRemoteNotificaitons
{
    if (iOS8) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    _registerRemoteNotificaitonsFlag = YES;
}

- (void)unregisterRemoteNotifications
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    _registerRemoteNotificaitonsFlag = NO;
}

- (void)didReceiveDeviceToken:(NSData *)data orError:(NSError *)error
{
    if (data) {
        self.deviceToken = data;
    
        const char *dataBytes = [data bytes];
        NSMutableString *string = [NSMutableString string];
        for (int i=0; i<data.length; i++) {
            [string appendFormat:@"%02.2hhx",dataBytes[i]];
        }
        self.deviceTokenStr = string;
        
    }else{
        self.error = error;
    }
    
    if ([self.delegate respondsToSelector:@selector(notificationHelper:didReceivedDeviceToken:)]) {
        [self.delegate notificationHelper:self didReceivedDeviceToken:self.deviceTokenStr];
    }
}

- (BOOL)isRegisteredForRemoteNotifications
{
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
}

#pragma mark - Settings
- (void)setIconBadgeNumber:(NSUInteger)number
{
    if (iOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
}

- (void)registerNotificationType:(YGNotificaitonType)type
{
    if (!_registerRemoteNotificaitonsFlag) {
        [self registerRemoteNotificaitons];
    }
    
    if (iOS10) {
        UNAuthorizationOptions options = 0;
        if (type & YGNotificaitonTypeBadge) {
            options |= UNAuthorizationOptionBadge;
        }
        if (type & YGNotificaitonTypeAlert) {
            options |= UNAuthorizationOptionAlert;
        }
        if (type & YGNotificaitonTypeSound) {
            options |= UNAuthorizationOptionSound;
        }
        [UNCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
            self.error = error;
        }];
    }else if (iOS8){
        UIUserNotificationType settingsType = type_iOS8_And_iOS9(type);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:settingsType categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType remoteType = type_iOS7_And_Earlier(type);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:remoteType];
    }
}

- (void)isNotificationTypeEnabled:(YGNotificaitonType)type completion:(void(^)(BOOL enabled))completion
{
    if (!completion) return;
    
    if (iOS10) {
        [UNCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            BOOL enabled = NO;
            switch (type) {
                case YGNotificaitonTypeNone:break;
                case YGNotificaitonTypeBadge: enabled = (settings.badgeSetting==UNNotificationSettingEnabled);break;
                case YGNotificaitonTypeSound: enabled = (settings.soundSetting==UNNotificationSettingEnabled);break;
                case YGNotificaitonTypeAlert: enabled = (settings.alertSetting==UNNotificationSettingEnabled);break;
            }
            completion(enabled);
        }];
    }else if(iOS8){
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        BOOL enabled = NO;
        switch (type) {
            case YGNotificaitonTypeNone:break;
            case YGNotificaitonTypeBadge: enabled = (settings.types&UIUserNotificationTypeBadge);break;
            case YGNotificaitonTypeSound: enabled = (settings.types&UIUserNotificationTypeSound);break;
            case YGNotificaitonTypeAlert: enabled = (settings.types&UIUserNotificationTypeAlert);break;
        }
        completion(enabled);
    }else{
        UIRemoteNotificationType remoteType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        BOOL enabled = NO;
        switch (type) {
            case YGNotificaitonTypeNone:break;
            case YGNotificaitonTypeBadge: enabled = (remoteType&UIRemoteNotificationTypeBadge);break;
            case YGNotificaitonTypeSound: enabled = (remoteType&UIRemoteNotificationTypeSound);break;
            case YGNotificaitonTypeAlert: enabled = (remoteType&UIRemoteNotificationTypeAlert);break;
        }
        completion(enabled);
    }
}

#pragma mark - Notification
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([self.delegate respondsToSelector:@selector(notificationHelper:didReceivedRemoteNotification:)]) {
        [self.delegate notificationHelper:self didReceivedRemoteNotification:userInfo];
    }
}

- (void)didReceiveLocalNotification:(UILocalNotification *)noti
{
    if ([self.delegate respondsToSelector:@selector(notificationHelper:didReceivedLocalNotification:)]) {
        [self.delegate notificationHelper:self didReceivedLocalNotification:noti];
    }
}

- (void)alertNotificationUseStyle:(YGNotificaitonForegroundStyle)style userInfo:(NSDictionary *)userInfo
{
    switch (style) {
        case YGNotificaitonForegroundStyleIgnore:{
            
        }   break;
        case YGNotificaitonForegroundStyleNoAlert:{
            // 直接响应
            [self didReceiveRemoteNotification:userInfo];
        }   break;
        case YGNotificaitonForegroundStyleDefault:{
            
            // iOS10之前的弹一个提示框 iOS10使用系统自带样式
            if (IS_iOS8 || IS_iOS9) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"推送消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[YGRemoteNotificationHelper shared] responseRemoteNotification:userInfo isCanceled:NO];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[YGRemoteNotificationHelper shared] responseRemoteNotification:userInfo isCanceled:YES];
                }]];
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alert animated:YES completion:nil];
            }else if (IS_iOS7){
                _YGAlertView *alert = [[_YGAlertView alloc] initWithTitle:@"推送消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
                alert.userInfo = userInfo;
                alert.tag = YGNotificationAlertViewTag;
                [alert show];
            }
        }   break;
        case YGNotificaitonForegroundStyleCustom:{
            // 显示自定义的提示框
            if ([self.delegate respondsToSelector:@selector(notificationHelper:willAlertUseCustomStyle:)]) {
                [self.delegate notificationHelper:self willAlertUseCustomStyle:userInfo];
            }
        }   break;
    }
}

- (void)alertView:(_YGAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == YGNotificationAlertViewTag) {
        [[YGRemoteNotificationHelper shared] responseRemoteNotification:alertView.userInfo isCanceled:buttonIndex == [alertView cancelButtonIndex]];
    }
}

@end

#pragma mark - UNCenter Delegate
NO_WARNING_BEGIN(-Wunguarded-availability)
@implementation YGRemoteNotificationHelper (UNUserNotificationCenterSupport)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    YGNotificaitonForegroundStyle style = YGNotificaitonForegroundStyleDefault;
    if ([self.delegate respondsToSelector:@selector(notificationHelper:styleInForeground:)]) {
        style = [self.delegate notificationHelper:self styleInForeground:notification.request.content.userInfo];
    }
    UNNotificationPresentationOptions options;
    if (style == YGNotificaitonForegroundStyleDefault) {
        options = UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert;
    }else{
        options = UNNotificationPresentationOptionNone;
    }
    completionHandler(options);
    [self alertNotificationUseStyle:style userInfo:notification.request.content.userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    [[YGRemoteNotificationHelper shared] responseRemoteNotification:response.notification.request.content.userInfo isCanceled:NO];
    completionHandler();
}
@end
NO_WARNING_END

#pragma mark - AppDelegate
@implementation AppDelegate (YGNotification)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[YGRemoteNotificationHelper shared] didReceiveDeviceToken:deviceToken orError:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[YGRemoteNotificationHelper shared] didReceiveDeviceToken:nil orError:error];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    YGNotificaitonForegroundStyle style = YGNotificaitonForegroundStyleDefault;
    if ([[YGRemoteNotificationHelper shared].delegate respondsToSelector:@selector(notificationHelper:styleInForeground:)]) {
        style = [[YGRemoteNotificationHelper shared].delegate notificationHelper:[YGRemoteNotificationHelper shared] styleInForeground:userInfo];
    }
    [[YGRemoteNotificationHelper shared] alertNotificationUseStyle:style userInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[YGRemoteNotificationHelper shared] didReceiveLocalNotification:notification];
}

@end
