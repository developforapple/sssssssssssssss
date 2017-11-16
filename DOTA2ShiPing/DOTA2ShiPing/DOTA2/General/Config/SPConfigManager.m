//
//  SPConfigManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPConfigManager.h"

#define Config_BOOL_Option_Setter(NAME)     \
    - (void)setSp_config_##NAME :(BOOL)value    { _sp_config_##NAME = value;            [self save];}

#define Config_int_Option_Setter(NAME)      \
    - (void)setSp_config_##NAME :(int)value     { _sp_config_##NAME = value;            [self save];}

#define Config_double_Option_Setter(NAME)   \
    - (void)setSp_config_##NAME :(double)value  { _sp_config_##NAME = value;            [self save];}

#define Config_float_Option_Setter(NAME)    \
    - (void)setSp_config_##NAME :(float)value   { _sp_config_##NAME = value;            [self save];}

#define Config_NSString_Option_Setter(NAME) \
    - (void)setSp_config_##NAME :(NSString *)value { _sp_config_##NAME = [value copy];  [self save];}

#define Config_NSNumber_Option_Setter(NAME) \
    - (void)setSp_config_##NAME :(NSNumber *)value { _sp_config_##NAME = [value copy];  [self save];}

#define Config_id_Option_Setter(NAME)       \
    - (void)setSp_config_##NAME :(id)value      { _sp_config_##NAME = value;            [self save];}

static NSString *const kSPConfigSaveKey = @"sp_config_key";

@interface SPConfigManager () <YYModel,NSCopying,NSCoding>

@end

@implementation SPConfigManager

YYModelDefaultCode

+ (instancetype)manager
{
    static SPConfigManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SPConfigManager new];
        [manager update];
    });
    return manager;
}

- (void)update
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSPConfigSaveKey];
    if (data) {
        [self yy_modelSetWithJSON:data];
    }else{
        [self setupDefaultValue];
    }
}

- (void)setupDefaultValue
{
    _sp_config_item_detail_show_loading_tips = YES;
    _sp_config_item_detail_load_extra_data_auto = YES;
    _sp_config_item_detail_load_price_auto = YES;
    
    [self save];
}

- (void)save
{
    NSData *data = [self yy_modelToJSONData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSPConfigSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Setter

Config_BOOL_Option_Setter(item_detail_show_loading_tips)
Config_BOOL_Option_Setter(item_detail_load_extra_data_auto)
Config_BOOL_Option_Setter(item_detail_load_price_auto)

@end
