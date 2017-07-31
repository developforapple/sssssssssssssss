//
//  SPItem.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSMutableSet *kItemKeys;

@class SPItemChild;
@class SPItemAutograph;
@class SPItemStyle;

@class UIColor;

@interface SPItem : NSObject

- (BOOL)isBundle;   //是否是一个套装
- (BOOL)isInBundle; //是否包含于一个套装
- (BOOL)isWearable; //是否是一个可穿戴的饰品
- (BOOL)isTaunt;    //是否是一个嘲讽

- (UIColor *)itemColor;
- (NSString *)nameWithQualtity;

// key
@property (strong, nonatomic) NSNumber *token;  // 20818

// data
@property (strong, nonatomic) NSNumber *creation_date;      //1363881600
@property (strong, nonatomic) NSString *image_inventory;    //econ/loading_screens/storm_spring_loadingscreen
@property (strong, nonatomic) NSString *item_description;   //#DOTA_Item_Desc_Sizzling_Charge
@property (strong, nonatomic) NSString *item_name;          //#DOTA_Item_Sizzling_Charge
@property (strong, nonatomic) NSString *item_rarity;        //rare
@property (strong, nonatomic) NSString *name;               //Sizzling Charge
@property (strong, nonatomic) NSString *prefab;             //bundle
@property (strong, nonatomic) NSString *item_type_name;     //#DOTA_WearableType_Sword
@property (strong, nonatomic) NSString *image_banner;       //econ/leagues/subscriptions_vietnams2_ingame
@property (strong, nonatomic) NSString *tournament_url;     //http://esportsviet.vn/vecl
@property (strong, nonatomic) NSString *item_slot;          //neck
@property (strong, nonatomic) NSString *item_quality;

@property (strong, nonatomic) NSString *purchase_requirement_prompt_text;    //db name: prpt
@property (strong, nonatomic) NSString *purchase_requires_owning_league_id;  //db name: proli
@property (strong, nonatomic) NSString *purchase_requirement_prompt_ok_text; //db name: prpot
@property (strong, nonatomic) NSString *purchase_requirement_prompt_ok_event;//db name: prpoe
@property (strong, nonatomic) NSString *purchase_through_event;              //db name: pte

@property (strong, nonatomic) NSString *override_attack_attachments; //覆盖攻击 //db name: oaa
@property (strong, nonatomic) NSString *event_id;           //EVENT_ID_FALL_MAJOR_2015
@property (strong, nonatomic) NSString *expiration_date;    //结束时间
@property (strong, nonatomic) NSString *player_loadout;
@property (strong, nonatomic) NSString *associated_item;
@property (strong, nonatomic) NSString *item_class;

//只保存一个 workshoplink 比如pc cold的亲笔签名 281702591
@property (strong, nonatomic) NSNumber *autograph;
// 饰品所属英雄。使用 || 分隔
@property (strong, nonatomic) NSString *heroes;
// 捆绑包中的饰品 使用 || 分隔
@property (strong, nonatomic) NSString *bundleItems;
// 饰品所属的捆绑包，使用 || 分隔
@property (strong, nonatomic) NSString *bundles;
// 箱子的掉落列表 
@property (strong, nonatomic) NSString *lootList;

// 款式。原始数据，JSON格式
@property (strong, nonatomic) NSString *styles;

// child
@property (strong, nonatomic) SPItemChild *child;

@property (strong, nonatomic) NSString *image_inventory_large;

- (NSArray<SPItemStyle *> *)stylesObjects;

///*
// {
// "armor of sizzling charge" = 1;
// "hat of sizzling charge" = 1;
// "pauldrons of sizzling charge" = 1;
// "sizzling charge loading screen" = 1;
// }
// */
//@property (strong, nonatomic) NSDictionary *bundle;        //TODO
//
///*
// {
// "npc_dota_hero_storm_spirit" = 1;
// }
// */
//@property (strong, nonatomic) NSDictionary *used_by_heroes; //TODO
//
///*
// {
// "is_weapon" = 1;
// }
// */
//@property (strong, nonatomic) NSDictionary *tags;
//
///*
// {
// type = "league_view_pass";
// "use_string" = "#ConsumeItem";
// }
// child keys: usage
// */
//@property (strong, nonatomic) NSDictionary *tool;

@end

@interface SPItemChild : NSObject

@property (strong, nonatomic) SPItemAutograph *autograph;

@property (strong, nonatomic) NSDictionary *static_attributes;

@property (strong, nonatomic) NSDictionary *additional_info;

@property (strong, nonatomic) NSArray<NSString *> *bundle;

@property (strong, nonatomic) NSArray<NSString *> *used_by_heroes;

@property (strong, nonatomic) NSDictionary *visuals;

@end


/*
 {(
 "item_type_name",
 "purchase_requirement_prompt_text",
 developer,
 "min_ilevel",
 "item_description",
 "override_attack_attachments",
 "perfect_world_explicit_whitelist",
 "purchase_requires_owning_league_id",
 token,
 "mouse_pressed_sound",
 "show_in_armory",
 "image_inventory_overlay",
 "sound_material",
 "has_store_custom_item_details_panel",
 "event_id",
 "premium_point_cost",
 "hide_tradecraftdelete",
 "expiration_date",
 "purchase_requirement_prompt_ok_text",
 "particle_snapshot",
 "model_player1",
 "image_inventory_size_w",
 "tournament_url",
 "reward_sound",
 "model_player3",
 child,
 "disable_style_selector",
 "purchase_requirement_prompt_ok_event",
 "frostivus_premium_price",
 "creation_date",
 "image_banner",
 "player_loadout",
 "event_premium_price",
 "ignore_in_collection_view",
 "hide_quantity",
 "item_quality",
 "frostivus_price",
 name,
 "image_inventory",
 "associated_item",
 "used_by_heroes",
 prefab,
 "free_cafe_equip",
 "event_point_id",
 "forced_item_quality",
 "tooltip_banner",
 "item_class",
 baseitem,
 "item_name",
 "drop_sound",
 hidden,
 "item_slot",
 propername,
 "purchase_through_event",
 "file://resources/layout/treasures/nested_treasure_ii.xml",
 "model_player",
 "model_player2",
 "item_rarity",
 "particle_folder",
 "preview_override_def_index",
 "max_ilevel",
 "image_inventory_size_h"
 )}

 */


@interface SPItemAutograph : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *workshoplink;
@property (strong, nonatomic) NSNumber *language;
@property (strong, nonatomic) NSNumber *filename_override;
@property (strong, nonatomic) NSString *icon_path;
@end

//@interface SPItemStyle : NSObject
//@property (strong, nonatomic) NSNumber *index;
//@property (strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSString *skin;
//@property (strong, nonatomic) NSString *alternate_icon;
//@end
