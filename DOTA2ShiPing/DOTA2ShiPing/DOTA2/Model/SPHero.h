//
//  SPHero.h
//  ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPItemCommon.h"
#import "SPItemSlot.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPHero : SPObject

// npc_dota_hero_earthshaker
@property (copy, nonatomic) NSString *name;
// 1
@property (copy, nonatomic) NSString *HeroID;
// 阵营，分为 Good 和 Bad
@property (copy, nonatomic) NSString *Team;
// 颜色。"120 64 148"
@property (copy, nullable, nonatomic) NSString *HeroGlowColor;
// 别名。逗号分隔。
@property (copy, nullable, nonatomic) NSString *NameAliases;
//
@property (copy, nullable, nonatomic) NSString *workshop_guide_name;
// 部位列表
@property (strong, nonatomic) NSArray<SPItemSlot *> *ItemSlots;
// 主属性：DOTA_ATTRIBUTE_AGILITY
@property (copy, nonatomic) NSString *AttributePrimary;


// 后期生成属性
// 属性分类
@property (assign, nonatomic) SPHeroType type;
// 阵营分类
@property (assign, nonatomic) SPHeroCamp camp;
// 是否在历史记录中
@property (assign, nonatomic) BOOL record;
// 本地化的名字
@property (copy, nonatomic) NSString *name_loc;
- (void)setName_loc:(NSString * _Nonnull)name_loc;

- (NSString *)smallImageURL;
- (NSString *)vertImageURL;
- (NSString *)iconURL;

@end

NS_ASSUME_NONNULL_END
