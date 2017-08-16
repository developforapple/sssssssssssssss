//
//  SPItemCommon.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPItemCommon_h
#define SPItemCommon_h

typedef NS_ENUM(NSUInteger, SPItemEntranceType) {
    SPItemEntranceTypeOffPrice,     //今日特价
    SPItemEntranceTypeEvent,        //事件
    SPItemEntranceTypeHeroItem,     //英雄
    SPItemEntranceTypeCourier,      //信使
    SPItemEntranceTypeWorld,        //世界
    SPItemEntranceTypeHud,          //界面
    SPItemEntranceTypeAudio,        //音频
    SPItemEntranceTypeTreasure,     //珍藏
    SPItemEntranceTypeOther,        //其他
    SPItemEntranceTypeOnSale,       //饰品商店
    SPItemEntranceTypeMarket,       //交易市场
};

typedef NS_ENUM(NSInteger, SPHeroType) {
    SPHeroTypePow = 0,  //力量
    SPHeroTypeDex = 1,  //敏捷
    SPHeroTypeWit = 2,  //智力
};

typedef NS_ENUM(NSUInteger, SPHeroCamp) {
    SPHeroCampRadiant,  //天辉
    SPHeroCampDire,     //夜魇
};

typedef NS_ENUM(NSUInteger, SPItemListMode) {
    SPItemListModeTable,        //列表
    SPItemListModeGrid,         //网格
};

#define kSPItemListModeKey @"SPItemListMode"

#endif /* SPItemCommon_h */
