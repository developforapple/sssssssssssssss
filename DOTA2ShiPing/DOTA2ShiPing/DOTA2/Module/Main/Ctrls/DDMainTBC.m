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
@import ReactiveObjC;

@interface DDMainTBC ()
@property (assign, nonatomic) NSTimeInterval lastCheckTime;
@end

@implementation DDMainTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)rootViewControllerDidAppear:(UINavigationController *)navi
{
    [self checkUpdateIfNeed];
}

- (void)checkUpdateIfNeed
{
    if ([SPUpdateViewCtrl needUpdateNecessary]) {
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

@end
