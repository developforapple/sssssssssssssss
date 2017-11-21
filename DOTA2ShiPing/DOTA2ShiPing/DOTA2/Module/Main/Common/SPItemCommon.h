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
    SPItemEntranceTypeOffPrice = 0,     //今日特价
    SPItemEntranceTypeEvent = 1,        //事件
    SPItemEntranceTypeHeroItem = 2,     //英雄
    SPItemEntranceTypeCourier = 3,      //信使
    SPItemEntranceTypeWorld = 4,        //世界
    SPItemEntranceTypeHud = 5,          //界面
    SPItemEntranceTypeAudio = 6,        //音频
    SPItemEntranceTypeTreasureBundle = 7,     //珍藏与捆绑包
    SPItemEntranceTypeLeague = 8,       //联赛
    SPItemEntranceTypeOther = 9,        //其他
    SPItemEntranceTypeOnSale = 10,       //饰品商店
    SPItemEntranceTypeMarket = 11,       //交易市场
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
