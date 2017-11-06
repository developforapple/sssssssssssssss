//
//  SPHero.m
//  ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPHero.h"
#import "YYModel.h"

@interface SPHero() <YYModel>

@end

@implementation SPHero

YYModelDefaultCode

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"ItemSlots":[SPItemSlot class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([self.AttributePrimary isEqualToString:@"DOTA_ATTRIBUTE_AGILITY"]) {
        self.type = SPHeroTypeDex;
    }else if ([self.AttributePrimary isEqualToString:@"DOTA_ATTRIBUTE_STRENGTH"]){
        self.type = SPHeroTypePow;
    }else if ([self.AttributePrimary isEqualToString:@"DOTA_ATTRIBUTE_INTELLECT"]){
        self.type = SPHeroTypeWit;
    }
    self.camp = [self.Team isEqualToString:@"Good"] ? SPHeroCampRadiant : SPHeroCampDire ;
    return YES;
}

- (NSString *)smallImageURL
{
    return [NSString stringWithFormat:@"http://items-3-0.qiniudn.com/%@/herosmall",self.name];
}

- (NSString *)vertImageURL
{
    return [NSString stringWithFormat:@"http://items-3-0.qiniudn.com/%@_vert/herosmall",self.name];
}

- (NSString *)iconURL
{
    return [NSString stringWithFormat:@"http://items-3-0.qiniudn.com/%@_icon/herosmall",self.name];
}

@end
