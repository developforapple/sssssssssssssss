//
//  SPSettingOptionsViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPSettingOptionsViewCtrl.h"
#import "SPConfigManager.h"
#import "YGRemoteNotificationHelper.h"
@import AVOSCloud;

@interface SPSettingOptionsViewCtrl ()
@property (weak, nonatomic) IBOutlet UISwitch *apnsSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *autoPriceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *extraInfoSwitch;

@end

@implementation SPSettingOptionsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AVInstallation *i = [AVInstallation currentInstallation];
    BOOL deviceTokenValid = i.deviceToken.length > 0;
    BOOL on = [[i objectForKey:@"On"] boolValue];
    self.apnsSwitch.on = deviceTokenValid && on;
    
    self.autoPriceSwitch.on = Config.sp_config_item_detail_load_price_auto;
    self.extraInfoSwitch.on = Config.sp_config_item_detail_load_extra_data_auto;
}

- (IBAction)apnsOn:(id)sender
{
    AVInstallation *i = [AVInstallation currentInstallation];
    if (i.deviceToken.length == 0){
        if ([YGRemoteNotificationHelper shared].error){
            [SVProgressHUD showErrorWithStatus:@"请打开系统推送开关"];
            self.apnsSwitch.on = NO;
        }else{
            [[YGRemoteNotificationHelper shared] registerNotificationType:YGNotificationTypeAll];
        }
    }else{
        [i setObject:@(self.apnsSwitch.on) forKey:@"On"];
        [i saveInBackground];
    }
}

- (IBAction)autoPriceOn:(id)sender
{
    Config.sp_config_item_detail_load_price_auto = self.autoPriceSwitch.on;
}

- (IBAction)extraInfoOn:(id)sender
{
    Config.sp_config_item_detail_load_extra_data_auto = self.extraInfoSwitch.on;
}

@end
