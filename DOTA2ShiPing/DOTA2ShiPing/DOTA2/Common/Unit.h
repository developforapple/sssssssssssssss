//
//  Unit.h
//
//  Created by bo wang on 2017/4/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Unit_h
#define Unit_h

// 标记一个token的单位数量级
#define YG_UNIT(NAME,UNIT)

#define YG_UNIT_BASE        YG_UNIT("基本","个")

// 货币单位
#define YG_RMB_UNIT(text)   YG_UNIT("人民币",text)
#define YG_UNIT_YUAN        YG_RMB_UNIT("元")
#define YG_UNIT_JIAO        YG_RMB_UNIT("角")
#define YG_UNIT_FEN         YG_RMB_UNIT("分")

// 时间单位
#define YG_TIME_UNIT(text)  YG_UNIT("时间",text)
#define YG_UNIT_YEAR        YG_TIME_UNIT("年")
#define YG_UNIT_QUARTER     YG_TIME_UNIT("季度")
#define YG_UNIT_MONTH       YG_TIME_UNIT("月")
#define YG_UNIT_WEEK        YG_TIME_UNIT("周")
#define YG_UNIT_DAY         YG_TIME_UNIT("天")
#define YG_UNIT_HOUR        YG_TIME_UNIT("小时")
#define YG_UNIT_MINUTE      YG_TIME_UNIT("分钟")
#define YG_UNIT_SEC         YG_TIME_UNIT("秒")
#define YG_UNIT_MSEC        YG_TIME_UNIT("毫秒")

// 重量单位
#define YG_WEIGHT_UNIT(text) YG_UNIT("重量",text)
#define YG_UNIT_G           YG_WEIGHT_UNIT("克")
#define YG_UNIT_KG          YG_WEIGHT_UNIT("千克")
#define YG_UNIT_TON         YG_WEIGHT_UNIT("吨")

// 其他单位
#define YG_UNIT_KW_H        YG_UNIT("发电量","千瓦时")
#define YG_UNIT_MW_H        YG_UNIT("发电量","兆瓦时")

#endif /* Unit_h */
