//
//  DDMainTBC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "DDMainTBC.h"
#import "SPUpdateViewCtrl.h"
#import "SPResourceManager.h"
#import "SPDataManager.h"
@import ReactiveObjC;
@import AVOSCloud;

@interface DDMainTBC ()
@property (assign, nonatomic) NSTimeInterval lastCheckTime;
@end

@implementation DDMainTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkAppAvailability];
}

- (void)rootViewControllerDidAppear:(UINavigationController *)navi
{
    [self checkUpdateIfNeed];
}

- (void)checkUpdateIfNeed
{
    if (![SPDataManager isDataValid]) {
        _lastCheckTime = [[NSDate date] timeIntervalSince1970];
        [[SPUpdateViewCtrl instanceFromStoryboard] show];
    }else{
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        if (time - _lastCheckTime > 2*60*60 ) {
            _lastCheckTime = time;
            ygweakify(self);
            [RACObserve([SPResourceManager manager], needUpdate)
             subscribeNext:^(id  x) {
                 ygstrongify(self);
                 if (!x) {
                     return;
                 }
                 if ([x boolValue]) {
                     [self noticeNeedUpdate];
                 }
             }];
            [[SPResourceManager manager] checkUpdate];
        }
    }
}

- (void)noticeNeedUpdate
{
    [UIAlertController confirm:@"饰品数据库需要更新"
                       message:@""
                        cancel:@"取消"
                          done:@"更新"
                      callback:^(BOOL isDone) {
                          if (isDone) {
                              [self beginUpdateData];
                          }else{
                              [self addNeedUpdateBadge];
                          }
                      }];
}

- (void)beginUpdateData
{
    [[SPUpdateViewCtrl instanceFromStoryboard] show];
}

- (void)addNeedUpdateBadge
{
    UITabBarItem *item = [self tabBarItemOfTab:SPTabTypeMore];
    item.badgeValue = @"1";
}

- (void)checkAppAvailability
{
    RunOnGlobalQueue(^{
        AVObject *object = [AVObject objectWithClassName:@"BetaVersion" objectId:@"5a24057d2f301e0063043e4f"];
        NSError *error;
        BOOL suc = [object refresh:&error];
        if (suc) {
            BOOL appOK = YES;
            long long curVersion = [AppBuildVersion longLongValue];
#if InHouseVersion
            id betaV = [object objectForKey:@"BetaVersion"];
            if (betaV && [betaV respondsToSelector:@selector(longLongValue)]) {
                long long minVersion = [betaV longLongValue];
                appOK = curVersion >= minVersion;
            }
#else
            id v = [object objectForKey:@"Version"];
            if (v && [v respondsToSelector:@selector(longLongValue)]) {
                long long minVersion = [v longLongValue];
                appOK = curVersion >= minVersion;
            }
#endif
            if (!appOK) {
                RunOnMainQueue(^{
                    [UIAlertController alert:@"应用版本过低，请及时升级" message:@"请前往AppStore下载更新" callback:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id767324842"]];
                        RunAfter(2.f, ^{
                            //让app crash
                            [self performSelector:@selector(aCrashSelector:)];
                        });
                    }];
                });
            }
        }
        
    });
}

@end
