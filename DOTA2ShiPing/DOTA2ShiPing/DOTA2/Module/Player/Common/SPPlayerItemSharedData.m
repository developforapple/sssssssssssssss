//
//  SPPlayerItemSharedData.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/24.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPlayerItemSharedData.h"
#import "SPPlayerItemFilterUnit.h"

@interface SPPlayerItemSharedData ()
@property (strong, readwrite, nonatomic) NSArray<NSNumber *> *tokens;
@property (strong, readwrite, nonatomic) NSArray<SPPlayerItemFilterUnit *> *qualityTags;
@property (strong, readwrite, nonatomic) NSArray<SPPlayerItemFilterUnit *> *rarityTags;
@property (strong, readwrite, nonatomic) NSArray<SPPlayerItemFilterUnit *> *prefabTags;
@property (strong, readwrite, nonatomic) NSArray<SPPlayerItemFilterUnit *> *slotTags;
@property (strong, readwrite, nonatomic) NSArray<SPPlayerItemFilterUnit *> *heroTags;
@end

@implementation SPPlayerItemSharedData

- (void)setInventory:(SPPlayerInventory *)inventory
{
    _inventory = inventory;
    
    [self updateTags];
}

- (void)updateTags
{
    NSMutableDictionary *qualityList = [NSMutableDictionary dictionary];
    NSMutableDictionary *rarityList = [NSMutableDictionary dictionary];
    NSMutableDictionary *prefabList = [NSMutableDictionary dictionary];
    NSMutableDictionary *slotList = [NSMutableDictionary dictionary];
    NSMutableDictionary *heroList = [NSMutableDictionary dictionary];
    
    for (SPPlayerItemDetail *aPlayerItem in self.inventory.items) {
        if (aPlayerItem.qualityTag.internal_name) {
            qualityList[aPlayerItem.qualityTag.internal_name] = aPlayerItem.qualityTag.name;
        }
        if (aPlayerItem.rarityTag.internal_name){
            rarityList[aPlayerItem.rarityTag.internal_name] = aPlayerItem.rarityTag.name;
        }
        if (aPlayerItem.typeTag.internal_name){
            prefabList[aPlayerItem.typeTag.internal_name] = aPlayerItem.typeTag.name;
        }
        if (aPlayerItem.slotTag.internal_name){
            slotList[aPlayerItem.slotTag.internal_name] = aPlayerItem.slotTag.name;
        }
        if ( aPlayerItem.heroTag.internal_name &&
            ![aPlayerItem.heroTag.internal_name isEqualToString:@"DOTA_OtherType"] ){
            heroList[aPlayerItem.heroTag.internal_name] = aPlayerItem.heroTag.name;
        }
    }
    
    static NSArray *(^getSimpleTags)(SPPlayerItemFilterType,NSDictionary *) = ^NSArray *(SPPlayerItemFilterType type,NSDictionary *dict){
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in dict) {
            [array addObject:[SPPlayerItemFilterUnit unit:type title:dict[key] object:key]];
        }
        return array;
    };
    
    self.qualityTags = getSimpleTags(SPPlayerItemFilterTypeQuality, qualityList);
    self.rarityTags  = getSimpleTags(SPPlayerItemFilterTypeRarity,  rarityList);
    self.prefabTags  = getSimpleTags(SPPlayerItemFilterTypePrefab,  prefabList);
    self.slotTags    = getSimpleTags(SPPlayerItemFilterTypeSlot,    slotList);
    self.heroTags    = getSimpleTags(SPPlayerItemFilterTypeHero,    heroList);
}

- (NSArray<NSNumber *> *)tokens
{
    if (!_tokens) {
        _tokens = [self.inventory.items valueForKeyPath:@"defindex"];
    }
    return _tokens;
}

@end
