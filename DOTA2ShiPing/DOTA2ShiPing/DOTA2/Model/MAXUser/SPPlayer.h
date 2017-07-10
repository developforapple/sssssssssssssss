//
//  SPPlayer.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlayerItems.h"

@interface SPPlayer : NSObject <NSCoding,NSCopying>

@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *steam_id;
@property (assign, nonatomic) BOOL star;

- (NSNumber *)steamid17;
// 饰品列表
@property (strong, nonatomic) SPPlayerItemsList *itemList;
// 库存详细数据
@property (strong, nonatomic) SPPlayerInventory *inventory;

- (NSURL *)steamProfile;
- (NSURL *)dotamaxProfile;
- (NSURL *)dotabuffProfile;

@end

// 用户的steam社区资料可见性
typedef NS_ENUM(NSUInteger, SPPlayerCommunityVisibilityState) {
    SPCVState_Private = 1,            //私有
    SPCVState_FriendsOnly = 2,        //仅好友
    SPCVState_FriendsOfFriends = 3,   //好友的好友
    SPCVState_UsersOnly = 4,          //对注册用户可见
    SPCVState_Public = 5,             //公开的
};

// 用户当前状态
typedef NS_ENUM(NSUInteger, SPPlayerPersonaState) {
    SPPersonaState_OfflineOrPrivate = 0,    //离线或者资料不公开
    SPPersonaState_Online = 1,              //在线
    SPPersonaState_Busy = 2,                //忙
    SPPersonaState_Away = 3,                //离开
    SPPersonaState_Snooze = 4,              //打盹
    SPPersonaState_LookingToTrade = 5,      //寻找交易
    SPPersonaState_LookingToPlay = 6,       //找人一起玩
};

@class SPPlayerAliase;

@interface SPPlayerDetailInfo : NSObject <NSCoding,NSCopying>

@property (strong, nonatomic) NSString *avatar;      //32*32
@property (strong, nonatomic) NSString *avatarfull;  //184*184
@property (strong, nonatomic) NSString *avatarmedium;//64*64
@property (strong, nonatomic) NSNumber *communityvisibilitystate;//用户的社区资料可见性 SPPlayerCommunityVisibilityState
@property (strong, nonatomic) NSNumber *lastlogoff;   //上次在线时间戳
@property (strong, nonatomic) NSString *personaname;  //用户昵称
@property (strong, nonatomic) NSNumber *personastate; //用户当前状态 SPPlayerPersonaState
@property (strong, nonatomic) NSNumber *personastateflags;
@property (strong, nonatomic) NSNumber *profilestate; // 1用户配置了个人页 other:未配置个人页
@property (strong, nonatomic) NSString *profileurl;   // 用户个人页
@property (strong, nonatomic) NSNumber *steamid;      //steamid17

//---可选的
@property (strong, nonatomic) id commentpermission;   //用户个人页的公开评论
@property (strong, nonatomic) NSString *gameextrainfo;//如果用户在玩游戏。这里显示游戏名。
@property (strong, nonatomic) NSNumber *gameid;       //如果用户在玩游戏。这里显示游戏id。570为DOTA2
@property (strong, nonatomic) NSNumber *primaryclanid;//用户所在的组。最主要的组的id。
@property (strong, nonatomic) NSNumber *timecreated;  //账户创建日期的时间戳
@property (strong, nonatomic) NSString *realname;     //真实名字。
@property (strong, nonatomic) NSString *loccountrycode;//国家代码
@property (strong, nonatomic) NSString *locstatecode; //地区代码
@property (strong, nonatomic) NSString *loccityid;    //城市代码

// 需要额外请求
@property (strong, nonatomic) NSArray<SPPlayerAliase *> *aliases;       //曾用名

- (SPPlayer *)toPlayer;

@end

@interface SPPlayerAliase : NSObject<NSCoding,NSCopying>
@property (strong, nonatomic) NSString *newname;
@property (strong, nonatomic) NSString *timechanged;
@end

@interface SPPlayerFriend : NSObject<NSCoding,NSCopying>
@property (strong, nonatomic) NSNumber *steamid;    //steamid17
@property (strong, nonatomic) NSString *relationship;   //关系
@property (strong, nonatomic) NSNumber *friend_since;   //加好友时间
@end
