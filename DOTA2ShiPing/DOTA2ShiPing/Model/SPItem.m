//
//  SPItem.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItem.h"
#import "SPDataManager.h"

@interface SPItem () <YYModel>

@end

@implementation SPItem

- (BOOL)isBundle
{
    return [self.prefab isEqualToString:@"bundle"];
}

- (BOOL)isInBundle
{
    //TODO
    return NO;
}

- (BOOL)isWearable
{
    return [self.prefab isEqualToString:@"wearable"];
}

- (UIColor *)itemColor
{
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:self.item_rarity];
    SPItemColor *color = [[SPDataManager shared] colorOfName:rarity.color];
    return color.color;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{    
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"purchase_requirement_prompt_text":@"prpt",
             @"purchase_requires_owning_league_id":@"proli",
             @"purchase_requirement_prompt_ok_text":@"prpot",
             @"purchase_requirement_prompt_ok_event":@"prpoe",
             @"purchase_through_event":@"pte"};
}

- (NSString *)item_rarity
{
    if (!_item_rarity) {
        _item_rarity = @"common";
    }
    return _item_rarity;
}

- (NSString *)item_quality
{
    if (!_item_quality) {
        _item_quality = @"base";
    }
    return _item_quality;
}

- (NSString *)item_description
{
    if (!_item_description) {
        _item_description = [_item_name copy];
    }
    return _item_description;
}

//- (NSString *)prefab
//{
//    if (!_prefab) {
//        _prefab = @"item";
//    }
//    return _prefab;
//}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",[super description],self.token,self.item_name];
}

@end

@implementation SPItemChild

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *bundle = [dic[@"bundle"] mutableCopy];
    bundle[@"child"] = nil;
    self.bundle = [bundle allKeys];
    
    NSMutableDictionary *used_by_heroes = [dic[@"used_by_heroes"] mutableCopy];
    used_by_heroes[@"child"] = nil;
    self.used_by_heroes = [used_by_heroes allKeys];
    
    return YES;
}

@end

@implementation SPItemAutograph

@end