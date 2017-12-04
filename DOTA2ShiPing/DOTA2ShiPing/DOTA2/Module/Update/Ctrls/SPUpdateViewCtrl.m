//
//  SPUpdateViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPUpdateViewCtrl.h"
#import "SPResourceManager.h"
#import "SPDataManager.h"
#import "ReactiveObjC.h"

@import AFNetworking.AFNetworkReachabilityManager;

@interface SPUpdateViewCtrl ()
@property (weak, nonatomic) IBOutlet UIView *updateView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *retryBtn;

@end

@implementation SPUpdateViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SPDataManager isDataValid]) {
        self.stateLabel.text = @"首次使用，需要下载基础数据";
    }else{
        self.stateLabel.text = @"正在获取更新信息";
    }
    self.progressLabel.text = @"";
    self.retryBtn.hidden = YES;
    
    [self initSignal];
    [self setupCompletion];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkUpdate];
}

- (void)initSignal
{
    SPResourceManager *manager = [SPResourceManager manager];
    ygweakify(self);
    [RACObserve(manager, error)
     subscribeNext:^(NSError *x) {
         if (x) {
             ygstrongify(self);
             [UIAlertController alert:nil message:x.localizedDescription];
             [self showError];
         }
     }];
    [RACObserve(manager, needUpdate)
     subscribeNext:^(NSNumber *x) {
         ygstrongify(self);
         if (x) {
             if (x.boolValue) {
                 [self beginUpdate];
             }else{
                 [self isLatestVersion];
             }
         }
     }];
    [RACObserve(manager, progress)
     subscribeNext:^(NSNumber *x) {
         ygstrongify(self);
         self.progressLabel.text = [NSString stringWithFormat:@"%02d%%",(int)(x.floatValue*100)];
     }];
}

- (void)setupCompletion
{
    ygweakify(self);
    SPResourceManager *manager = [SPResourceManager manager];
    manager.downloadCompleted = ^{
        ygstrongify(self);
        self.progressLabel.text = @"解压缩中...";
        [self beginUnzip];
    };
    manager.unzipCompleted = ^{
        ygstrongify(self);
        self.progressLabel.text = @"保存中...";
        [self saveData];
    };
    manager.completion = ^{
        ygstrongify(self);
        [self done];
    };
}

- (void)beginUnzip
{
    [[SPResourceManager manager] beginUnzip];
}

- (void)saveData
{
    [[SPResourceManager manager] saveData];
}

- (void)checkUpdate
{
    [[SPResourceManager manager] checkUpdate];
}

- (void)showError
{
    [self.updateView setHidden:YES animated:YES];
    [self.retryBtn setHidden:NO animated:YES];
}

- (void)beginUpdate
{
    [[SPResourceManager manager] beginUpdate];
}

- (void)isLatestVersion
{
    self.progressLabel.text = @"已经是最新版本";
    [self dismiss:^{
        [SVProgressHUD showInfoWithStatus:@"已是最新版本"];
    }];
}

- (void)done
{
    self.progressLabel.text = @"更新完成";
    [self dismiss:^{
        [SVProgressHUD showSuccessWithStatus:@"更新完成"];
    }];
}

- (IBAction)retry:(id)sender
{
    [[SPResourceManager manager] clean];
    [self setupCompletion];
    
    [self.retryBtn setHidden:YES animated:YES];
    [self.updateView setHidden:NO animated:YES];
    self.progressLabel.text = @"";
    [self checkUpdate];
}

@end
