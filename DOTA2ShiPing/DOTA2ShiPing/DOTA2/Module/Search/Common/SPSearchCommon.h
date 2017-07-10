//
//  SPSearchCommon.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#ifndef SPSearchCommon_h
#define SPSearchCommon_h

typedef NS_ENUM(NSUInteger, SPSearchType) {
    SPSearchTypeMaxPlusPlayer,       //搜索max+的用户
    SPSearchTypeDotabuffPlayer,      //搜索Dotabuff的用户
    SPSearchTypeSteamCommunityPlayer,//搜索steam社区的用户
    SPSearchTypeItemName,            //搜索饰品名称
};

#define kSPUserSearchTypeSettingKey @"SPUserSearchType"

// 是否是搜索用户
NS_INLINE BOOL IsSearchPlayer(SPSearchType type){
    return type==SPSearchTypeMaxPlusPlayer||type==SPSearchTypeDotabuffPlayer||type==SPSearchTypeSteamCommunityPlayer;
}

// 已配置的用户搜索方式
NS_INLINE SPSearchType UserSearchType(){
    return [[NSUserDefaults standardUserDefaults] integerForKey:kSPUserSearchTypeSettingKey];
}

// 配置用户搜索方式
NS_INLINE void SetUserSearchType(SPSearchType type){
    [[NSUserDefaults standardUserDefaults] setInteger:IsSearchPlayer(type)?type:-1 forKey:kSPUserSearchTypeSettingKey];
}

#endif /* SPSearchCommon_h */
