//
//  SPItem.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItem.h"
#import "SPDataManager.h"
#import "YYModel.h"
#import "SPItemStyle.h"

@interface SPItem () <YYModel>
{
    UIColor *_itemColor;
    NSString *_nameWithQualtity;
    NSString *_enNameWithQuality;
    NSString *_market_hash_name;
}
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

- (BOOL)isTaunt
{
    return [self.prefab isEqualToString:@"taunt"];
}

- (UIColor *)itemColor
{
    if (!_itemColor) {
        if ([self.item_quality isEqualToString:@"base"] ||
            [self.item_quality isEqualToString:@"unique"]) {
            
            SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:self.item_rarity];
            SPItemColor *color = [[SPDataManager shared] colorOfName:rarity.color];
            _itemColor = color.color;
            
        }else{
            SPItemQuality *qualtity = [[SPDataManager shared] qualityOfName:self.item_quality];
            _itemColor = HEXColor(qualtity.hexColor);
        }
    }
    return _itemColor;
}

- (NSString *)nameWithQualtity
{
    if (!_nameWithQualtity) {
        NSString *name = SPLOCAL(self.item_name, self.name);
        if ([self.item_quality isEqualToString:@"base"] ||
            [self.item_quality isEqualToString:@"unique"]) {
            _nameWithQualtity = name;
        }else{
            SPItemQuality *qualtity = [[SPDataManager shared] qualityOfName:self.item_quality];
            _nameWithQualtity = [NSString stringWithFormat:@"%@ %@",qualtity.name_loc,name];
        }
    }
    return _nameWithQualtity;
}

- (NSString *)enNameWithQuality
{
    if (!_enNameWithQuality) {
        NSString *name = self.name;
        if ([self.item_quality isEqualToString:@"base"] ||
            [self.item_quality isEqualToString:@"unique"]) {
            _enNameWithQuality = name;
        }else{
            SPItemQuality *qualtity = [[SPDataManager shared] qualityOfName:self.item_quality];
            _enNameWithQuality = [NSString stringWithFormat:@"%@ %@",qualtity.name,name];
        }
    }
    return _enNameWithQuality;
}

- (NSString *)market_hash_name
{
    if (!_market_hash_name) {
        NSString *name = self.name;
        if ([self.item_quality isEqualToString:@"base"] ||
            [self.item_quality isEqualToString:@"unique"]) {
            _market_hash_name = name;
        }else{
            SPItemQuality *qualtity = [[SPDataManager shared] qualityOfName:self.item_quality];
            _market_hash_name = [NSString stringWithFormat:@"%@ %@",[qualtity.name capitalizedString],name];
        }
    }
    return _market_hash_name;
}

- (NSString *)dota2MarketURL
{
    return [NSString stringWithFormat:@"http://store.dota2.com.cn/itemdetails/%@",self.token];
}

- (NSString *)steamMarketURL
{
    return [NSString stringWithFormat:@"http://steamcommunity.com/market/listings/570/%@",[self.market_hash_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if (!self.name) {
        self.name = @"";
    }
    if (!self.item_name) {
        self.item_name = @"";
    }
    
    if (self.item_slot.length == 0) {
        if ([self.prefab isEqualToString:@"wearable"]) {
            self.item_slot = @"weapon";
        }else if ([self.prefab isEqualToString:@"taunt"]){
            self.item_slot = @"taunt";
        }
    }
    
    // 实现计算出颜色
    __unused UIColor *color = [self itemColor];
    
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"purchase_requirement_prompt_text":@"prpt",
             @"purchase_requires_owning_league_id":@"proli",
             @"purchase_requirement_prompt_ok_text":@"prpot",
             @"purchase_requirement_prompt_ok_event":@"prpoe",
             @"purchase_through_event":@"pte",
             @"lootList":@"lootlist"};
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

- (NSArray<SPItemStyle *> *)stylesObjects
{
    NSArray<SPItemStyle *> *objects = [NSArray yy_modelArrayWithClass:[SPItemStyle class] json:self.styles];
    NSArray *sorted = [objects sortedArrayUsingComparator:^NSComparisonResult(SPItemStyle *obj1, SPItemStyle *obj2) {
        return [@(obj1.index.intValue) compare:@(obj2.index.intValue)];
    }];
    return sorted;
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

@implementation SPItemAutograph

@end
