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
#import "SPIAPHelper.h"
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
    AVQuery *query = [AVQuery queryWithClassName:@"Availability"];
    [query whereKey:@"Key" equalTo:AppBundleID];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (error || !object){
            NSLog(@"查询 Availability 出错！");
            return ;
        }
        
        BOOL appOK = YES;
        BOOL isProduction = YES;
        long long curVersion = [AppBuildVersion longLongValue];
        
        id minV = [object objectForKey:@"MinVersion"];
        id maxV = [object objectForKey:@"MaxVersion"];
        
        NSLog(@"当前app版本：%lld",curVersion);
        NSLog(@"最小支持版本：%@",minV);
        NSLog(@"最大线上版本：%@",maxV);
        
        if ([minV respondsToSelector:@selector(longLongValue)]){
            long long minVersion = [minV longLongValue];
            appOK = curVersion >= minVersion;
        }
        if ([maxV respondsToSelector:@selector(longLongValue)]){
            long long maxVersion = [maxV longLongValue];
            isProduction = curVersion <= maxVersion;
        }
        
        [SPIAPHelper setProduction:isProduction];
        
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
    }];
}

@end
