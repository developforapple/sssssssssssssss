//
//  SPSettingOptionsViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPSettingOptionsViewCtrl.h"
#import "SPConfigManager.h"

@interface SPSettingOptionsViewCtrl ()
@property (weak, nonatomic) IBOutlet UISwitch *apnsSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *autoPriceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *extraInfoSwitch;

@end

@implementation SPSettingOptionsViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.autoPriceSwitch.on = Config.sp_config_item_detail_load_price_auto;
    self.extraInfoSwitch.on = Config.sp_config_item_detail_load_extra_data_auto;
}

- (IBAction)apnsOn:(id)sender
{
    
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
