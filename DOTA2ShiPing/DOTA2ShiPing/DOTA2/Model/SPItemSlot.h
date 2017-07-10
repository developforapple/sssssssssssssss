//
//  SPItemSlot.h
//  ShiPing
//
//  Created by wwwbbat on 16/4/15.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

// Hero slot
//{(
//  neck,
//  weapon,
//  "ability_ultimate",
//  shoulder,
//  belt,
//  ability3,
//  shapeshift,
//  voice,
//  tail,
//  "offhand_weapon",
//  misc,
//  mount,
//  summon,
//  ability4,
//  gloves,
//  ability1,
//  head,
//  "body_head",
//  arms,
//  back,
//  legs,
//  weapon2,
//  "offhand_weapon2",
//  armor,
//  taunt,
//  ability2
//  )}





/*
 {(
 arms,                  手臂              done
 ability2,              技能2
 head,                  头部              done
 "mega_kills",          连杀系统广播
 tail,                  尾巴              done
 "ambient_effects",     模型特效
 taunt,                 嘲讽              done
 weapon,                武器              done
 shoulder,              肩部              done
 "multikill_banner",    多杀标语
 ability4,              技能4
 summon,                召唤单位
 weather,               天气
 "offhand_weapon",      副手              done
 ability1,              技能1
 mount,                 坐骑              done
 misc,                  杂项              done
 legs,                  腿部              done
 "teleport_effect",     传送特效
 gloves,                手套              done
 back,                  背部              done
 armor,                 护甲              done
 ability3,              技能3
 "ability_ultimate",    终极技能
 voice,                 配音              done
 "action_item",         动作物品
 "heroic_statue",       英雄雕像
 shapeshift,            变身              done    ability4
 belt,                  腰带              done
 none,                  无
 neck,                  颈部              done
 announcer,             系统广播
 "body_head"            身体 - 头部
 
 courier                信使
 ability_attack         默认攻击
 custom_hex             妖术效果
 fan_item               粉丝物品
 fan                    粉丝
 ward                   守卫
 hud_skin               游戏界面皮肤
 wolves                 精灵狼             done    summon
 loading_screen         载入画面
 elder_dragon           古龙形态           done     shapeshift
 music                  音乐
 abilityultimate        终极技能
 head_accessory         头饰               done    body_head
 shield                 盾牌               done    offhand_weapon
 wings                  翅膀               done     back
 quiver                 箭袋               done    offhand_weapon
 beard                  胡须               done    body_head
 heads                  头部
 leftarm                左臂               done
 rightarm               右臂               done
 body                   身体               done
 claws                  爪子               done
 alchemist_tinyarmor    微型护服            done
 alchemist_flask        烧瓶               done
 alchemist_tinyhead     微型头饰            done
 beastmaster_hawk       战鹰               done
 beastmaster_boar       豪猪               done
 brewmaster_barrel      酒桶               done
 broodmother_spiderling 小蜘蛛             done
 clockwerk_rocket       照明火箭            done
 clockwerk_cogs         能量齿轮             done
 death_prophet          能量齿轮             done
 death_spirits          恶灵              done
 earthspirit_stoneremnant   残岩          done
 earthshaker_totem      图腾              done
 eldertitan_astralspirit    星体游魂
 enigma_eidolons        虚灵体             done
 gyrocopter_guns        机枪              done
 gyrocopter_propeller   螺旋桨             done
 gyrocopter_missilecompartment 飞弹装置    done
 gyrocopter_homingmissile   追踪导弹
 invoker_forgespirit    熔炉精灵           done
 juggernaut_healingward 治疗守卫            ability2        jugg
 legioncommander_banners    战旗          done
 lonedruid_trueform     真正形态            done
 lonedruid_spiritbear   熊灵              done
 naturesprophet_treants 树人              done
 Pugna_netherward       幽冥守卫           done
 shadowshaman_serpentwards 群蛇守卫       done
 techies_cart           推车              done
 techies_bazooka        火箭炮            done
 techies_squee          斯奎              done
 techies_spoon          斯布恩             done
 techies_spleen         斯布林             done
 techies_remotemines    遥控炸弹           done
 techies_sign           标识              done
 terrorblade_demon      恶魔              done
 tusk_tusks             长牙              done
 tusk_fist              拳头              done
 tusk_frozensigil       冰封魔印          done
 undying_tombstone      墓碑              done
 undying_fleshgolem     血肉傀儡
 venomancer_stingerlimbs    毒刺肢干       done
 venomancer_plagueward  瘟疫守卫            done
 warlock_golem          地狱火             done
 warlock_lantern        灯笼              done
 warlock_evilpurse      邪包              done
 weaver_antennae        触角              done
 witchdoctor_deathward  死亡守卫           done
 
 cursor_pack        指针包
 blink_effect       闪烁特效
 trollwarlord_offhand_weapon_melee  副手近战武器 done
 trollwarlord_weapon_melee   近战武器           done
 pet                宠物                  done
 visage_familiar    佣兽                  done
 terrain            地图
 arc_warden_spark_wraith    闪光幽魂
 undying_flesh_golem        血肉傀儡
 
 
 
 )}
 */

//武器 肩   微型护服     护腕      微型头饰    护甲  烧瓶
//武器 肩膀 背部        护腕       项链       护甲  副手
//118  125  117       120        121       119  122   123 124
//[
//    {
//        "name_en":"asdfasdf",
//        "name_cn":"上古巨神",
//        "image":"http://123123123123",
//        "type":1,     //0 力量 1敏捷 2智力
//        "faction":1,  //0 天辉 1 夜魇
//        "slot":[      //槽位
//                {
//                    "item_slot":"head",
//                    "item_slot_cn":"头部",
//                },
//        ]
//        
//    },{
//        .....
//    }
//
//]





@interface SPItemSlot : NSObject <NSCopying,NSCoding>

@property (assign, nonatomic) BOOL player_loadout_slot;

@property (strong, nonatomic) NSString *name;           //英文名
@property (strong, nonatomic) NSString *name_cn;        //中文名
@property (strong, nonatomic) NSString *name_cn_hero;   //英雄部位的名称

@end
