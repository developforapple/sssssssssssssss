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
- (NSString *)enNameWithQuality;
- (NSString *)market_hash_name;

- (NSString *)dota2MarketURL;
- (NSString *)steamMarketURL;

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

@property (strong, nonatomic) NSString *image_inventory_large;

- (NSArray<SPItemStyle *> *)stylesObjects;

@end

@interface SPItemAutograph : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *workshoplink;
@property (strong, nonatomic) NSNumber *language;
@property (strong, nonatomic) NSNumber *filename_override;
@property (strong, nonatomic) NSString *icon_path;
@end
