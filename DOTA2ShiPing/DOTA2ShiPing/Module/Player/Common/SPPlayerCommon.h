//
//  SPPlayerCommn.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPPlayerCommon_h
#define SPPlayerCommon_h

typedef NS_ENUM(NSUInteger, SPInventoryCategory) {
    SPInventoryCategoryAll,      //全部
    SPInventoryCategoryEvent,    //事件
    SPInventoryCategoryHero ,   //英雄
    SPInventoryCategoryCourier , //信使
    SPInventoryCategoryWorld ,     //世界
    SPInventoryCategoryHud ,         //界面
    SPInventoryCategoryAudio ,     //音频
    SPInventoryCategoryTreasure ,   //珍藏
    SPInventoryCategoryOther,      //其他
    SPInventoryCategoryTradableSaleable,    //可交易或可出售
    SPInventoryCategoryFilter,      //使用筛选器
};

// 选项 中间是未指定 左边是假 右边是真
typedef NS_ENUM(NSInteger, SPConditionOption) {
    SPConditionOptionUndefined = 1,    //未指定
    SPConditionOptionTrue = 2,          //真
    SPConditionOptionFalse = 0,         //假
};

typedef NS_ENUM(NSUInteger, SPConditionType) {
    SPConditionTypeHero,
    SPConditionTypeQuality,
    SPConditionTypeRarity,
};

typedef NS_ENUM(NSUInteger, SPPlayerInventoryStatus) {
    SPPlayerInventoryStatusNoData,      //没有数据
    SPPlayerInventoryStatusNormal,      //正常
    SPPlayerInventoryStatusNeedUpdate,  //需要更新
    SPPlayerInventoryStatusUpdating,    //更新中
    SPPlayerInventoryStatusFailed,      //失败
};

#endif /* SPPlayerCommn_h */

