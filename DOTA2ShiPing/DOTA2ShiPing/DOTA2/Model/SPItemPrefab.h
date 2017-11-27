//
//  SPItemPrefab.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SPItemPrefab : SPObject

// courier
@property (copy, nonatomic) NSString *name;
// #DOTA_WearableType_Courier 需要本地化时，以这个为准
@property (copy, nonatomic) NSString *item_type_name;
// #DOTA_Wearable_Courier。没啥用
@property (copy, nonatomic) NSString *item_name;
// courier    没有时为 "none"
@property (copy, nullable, nonatomic) NSString *item_slot;
// 1   没有时为nil
@property (copy, nullable, nonatomic) NSString *player_loadout;

// 后期生成的属性
@property (copy, nonatomic) NSString *name_loc;

@end

/*
courier_wearable,
item,
blink_effect,
tool,
relic,
emoticon_tool,
player_card,
default_item,
teleport_effect,
cursor_pack,
wearable,
misc,
treasure_chest,
music,
courier,
announcer,
retired_treasure_chest,
hud_skin,
dynamic_recipe,
league,
passport_fantasy_team,
bundle,
ward,
modifier,
socket_gem,
pennant,
summons,
weather,
terrain,
taunt,
loading_screen,
key
*/

NS_ASSUME_NONNULL_END
