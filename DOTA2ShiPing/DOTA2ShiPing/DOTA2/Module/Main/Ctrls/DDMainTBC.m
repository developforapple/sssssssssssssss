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
@property (strong, nonatomic) SPResourceManager *manager;
@property (assign, nonatomic) NSTimeInterval lastCheckTime;
@end

@implementation DDMainTBC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[SPResourceManager alloc] init];
    [self initSignal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([SPUpdateViewCtrl needUpdateNecessary]) {
        _lastCheckTime = [[NSDate date] timeIntervalSince1970];
        [[SPUpdateViewCtrl instanceFromStoryboard] show];
    }else{
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        if (time - _lastCheckTime > 1 * 60 * 60) {
            _lastCheckTime = time;
            [self.manager checkUpdate];
        }
    }
}

- (void)initSignal
{
    ygweakify(self);
    [RACObserve(self.manager, needUpdate)
     subscribeNext:^(id  x) {
         ygstrongify(self);
         
         if (!x) {
             return;
         }
         
         if ([x boolValue]) {
             [self noticeNeedUpdate];
         }
     }];
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
    
}

@end
