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
};

// 选项
typedef NS_ENUM(NSInteger, SPConditionOption) {
    SPConditionOptionUndefined = -1,    //未指定
    SPConditionOptionTrue = 1,          //真
    SPConditionOptionFalse = 0,         //假
};

typedef NS_ENUM(NSUInteger, SPConditionType) {
    SPConditionTypeHero,
    SPConditionTypeQuality,
    SPConditionTypeRarity,
};

#endif /* SPPlayerCommn_h */

