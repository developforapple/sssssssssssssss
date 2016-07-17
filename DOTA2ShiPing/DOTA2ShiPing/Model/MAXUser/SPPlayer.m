//
//  SPPlayer.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayer.h"
#import "YYModel.h"
#import "SPMacro.h"
#import "SPConstant.h"

@interface SPPlayer () <YYModel>

@end

@implementation SPPlayer

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"itemList",@"inventory"];
}

- (NSNumber *)steamid17
{
    return @(self.steam_id.longLongValue + BaseSteamID());
}

- (NSURL *)steamProfile
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://steamcommunity.com/profiles/%@",self.steamid17]];
}

- (NSURL *)dotamaxProfile
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://dotamax.com/player/detail/%@",self.steam_id]];
}

- (NSURL *)dotabuffProfile
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.dotabuff.com/players/%@",self.steam_id]];
}

YYModelCopyingCodingCode
@end

@implementation SPPlayerDetailInfo
YYModelCopyingCodingCode;

- (SPPlayer *)toPlayer
{
    SPPlayer *player = [SPPlayer new];
    player.avatar_url = self.avatar;
    player.name = self.personaname;
    player.steam_id = @(self.steamid.longLongValue - BaseSteamID());
    return player;
}

@end

@implementation SPPlayerAliase
YYModelCopyingCodingCode
@end

@implementation SPPlayerFriend
YYModelCopyingCodingCode
@end
