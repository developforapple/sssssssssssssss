//
//  SPItemGameData.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDFNode.h"

@class SPItemGameModel;

@interface SPItemGameData : NSObject

+ (instancetype)shared;

- (void)dataWithRootNode:(VDFNode *)root;

@property (strong, nonatomic) SPItemGameModel *model;

//@property (strong, nonatomic) NSDictionary *prefabs;             //部位
//@property (strong, nonatomic) NSDictionary *qualities;           //前缀
//@property (strong, nonatomic) NSDictionary *rarities;            //稀有度
//@property (strong, nonatomic) NSDictionary *colors;              //颜色
//@property (strong, nonatomic) NSDictionary *player_loadout_slots;//通用部位
//
//@property (strong, nonatomic) NSDictionary *items;               //物品
//@property (strong, nonatomic) NSDictionary *item_sets;           //物品集合
//
//@property (strong, nonatomic) NSDictionary *items_autographs;    //签名
//@property (strong, nonatomic) NSDictionary *asset_modifiers;     //动能
//
//@property (strong, nonatomic) NSDictionary *loot_lists;          //掉落列表
//@property (strong, nonatomic) NSDictionary *attributes;
//@property (strong, nonatomic) NSDictionary *store_currency_pricepoints;

//@property (strong, nonatomic) NSDictionary *upgradeable_base_items;
//@property (strong, nonatomic) NSDictionary *game_info;
//@property (strong, nonatomic) NSDictionary *web_resources;
//@property (strong, nonatomic) NSDictionary *item_levels;
//@property (strong, nonatomic) NSDictionary *sound_materials;
//@property (strong, nonatomic) NSDictionary *attribute_controlled_attached_particles;
//@property (strong, nonatomic) NSDictionary *partners;
//@property (strong, nonatomic) NSDictionary *kill_eater_score_types;

@end

#import "SPItem.h"
#import "SPItemRarity.h"
#import "SPItemPrefab.h"
#import "SPItemQuality.h"
#import "SPHero.h"
#import "SPItemSlot.h"
#import "SPItemColor.h"
#import "SPItemSets.h"
#import "SPDotaEvent.h"
#import "SPLootList.h"

@interface SPItemGameModel : NSObject

@property (strong, nonatomic) NSArray<SPHero *> *heroes;
@property (strong, nonatomic) NSArray<SPDotaEvent *> *events;

@property (strong, nonatomic) NSArray<SPItem *> *items;
@property (strong, nonatomic) NSArray<SPItemRarity *> *rarities;
@property (strong, nonatomic) NSArray<SPItemPrefab *> *prefabs;
@property (strong, nonatomic) NSArray<SPItemQuality *> *qualities;
@property (strong, nonatomic) NSArray<SPItemSlot *> *slots; //player_loadout_slots
@property (strong, nonatomic) NSArray<SPItemColor *> *colors;
@property (strong, nonatomic) NSArray<SPItemSets *> *item_sets;

// key: item name  value: bundle name 集合 一个item可以属于多个包
@property (strong, nonatomic) NSDictionary<NSString *,NSSet<NSString *> *> *item_sets_map;

@property (strong, nonatomic) NSDictionary<NSString *,SPLootList *> *loot_list;

@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) NSData *jsonData;

- (void)save;

- (NSString *)versionPath;
- (NSDictionary *)version;
- (NSString *)zipFilePath;

@end
