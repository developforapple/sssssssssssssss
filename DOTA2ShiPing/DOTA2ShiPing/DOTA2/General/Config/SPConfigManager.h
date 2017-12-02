//
//  SPConfigManager.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

#define Config_BOOL_Option(NAME)        @property (assign,  nonatomic) BOOL         sp_config_##NAME ;
#define Config_NSInteger_Option(NAME)   @property (assign,  nonatomic) NSInteger    sp_config_##NAME ;
#define Config_double_Option(NAME)      @property (assign,  nonatomic) double       sp_config_##NAME ;
#define Config_float_Option(NAME)       @property (assign,  nonatomic) float        sp_config_##NAME ;
#define Config_NSString_Option(NAME)    @property (copy,    nonatomic) NSString *   sp_config_##NAME ;
#define Config_NSNumber_Option(NAME)    @property (copy,    nonatomic) NSNumber *   sp_config_##NAME ;
#define Config_id_Option(NAME)          @property (strong,  nonatomic) id           sp_config_##NAME ;

#define Config [SPConfigManager manager]

@interface SPConfigManager : SPObject 

+ (instancetype)manager;

// 饰品详情页是否显示loading的提示文本 默认YES
Config_BOOL_Option(item_detail_show_loading_tips)

// 进入饰品详情页时，是否自动抓取额外数据 默认YES
Config_BOOL_Option(item_detail_load_extra_data_auto)

// 进入饰品详情页时，是否自动抓取价格数据 默认YES
Config_BOOL_Option(item_detail_load_price_auto)

// 饰品详情页获取图片失败的计数器。默认为0。当获取图片失败时，手动使这个值+1
Config_NSInteger_Option(item_detail_load_image_failed_counter)

@end

