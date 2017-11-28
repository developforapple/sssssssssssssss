//
//  SPPlayerInventory.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerItems.h"

#pragma mark - 用户的库存清单
@interface SPPlayerItemsList    ()
@property (strong, nonatomic) NSMutableDictionary *mapping;
@end

@implementation SPPlayerItemsList

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"items":[SPPlayerItem class]};
}

- (NSNumber *)defindexOfItemID:(NSNumber *)itemid
{
    if (!itemid) return nil;
    
    if (!self.mapping) {
        self.mapping = [NSMutableDictionary dictionary];
        for (SPPlayerItem *item in self.items) {
            self.mapping[item.id] = item.defindex;
        }
    }
    return self.mapping[itemid];
}

- (void)removeHiddenItems:(NSSet<NSNumber *> *)defindexes;
{
    NSIndexSet *indexes = [self.items indexesOfObjectsPassingTest:^BOOL(SPPlayerItem *obj, NSUInteger idx, BOOL *stop) {
        return ![defindexes containsObject:obj.defindex];
    }];
    self.items = [self.items objectsAtIndexes:indexes];
}

YYModelDefaultCode
@end

@implementation SPPlayerItem
YYModelDefaultCode
@end

#pragma mark - 用户的库存详情
@implementation SPPlayerInventory

+ (NSIndexSet *)startIndexesOfItemsCount:(NSUInteger)count
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSUInteger idx = 0; idx < count ; idx+=2000) {
        [indexSet addIndex:idx];
    }
    return indexSet;
}

+ (instancetype)merge:(NSArray<SPPlayerInventory *> *)inventories
{
    NSMutableArray *items = [NSMutableArray array];
    for (SPPlayerInventory *inventory in inventories) {
        [items addObjectsFromArray:inventory.items];
    }
    SPPlayerInventory *tmp = [SPPlayerInventory new];
    tmp.items = items;
    return tmp;
}

- (void)infuseItemList:(SPPlayerItemsList *)list
{
    for (SPPlayerItemDetail *detail in self.items) {
        NSNumber *itemid = detail.id;
        NSNumber *defindex = [list defindexOfItemID:itemid];
        detail.defindex = defindex;
    }
}

#pragma mark YYModel

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"items":[SPPlayerItemDetail class]};
}

YYModelDefaultCode
@end

NSString *const kSPPlayerItemRarityTag = @"Rarity";
NSString *const kSPPlayerItemHeroTag = @"Hero";
NSString *const kSPPlayerItemTypeTag = @"Type";
NSString *const kSPPlayerItemQualityTag = @"Quality";
NSString *const kSPPlayerItemSlotTag = @"Slot";

@interface SPPlayerItemDetail ()
@property (strong, nonatomic) SPPlayerInvertoryItemTag *rarityTag;
@property (strong, nonatomic) SPPlayerInvertoryItemTag *heroTag;
@property (strong, nonatomic) SPPlayerInvertoryItemTag *typeTag;
@property (strong, nonatomic) SPPlayerInvertoryItemTag *qualityTag;
@property (strong, nonatomic) SPPlayerInvertoryItemTag *slotTag;
@end

@implementation SPPlayerItemDetail

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"descriptions":[SPPlayerInventoryItemDesc class],
             @"tags":[SPPlayerInvertoryItemTag class],
             @"fraudwarnings":[NSString class]};
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"rarityTag",@"heroTag",@"typeTag",@"qualityTag"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [self initTags];
    return YES;
}

- (void)initTags
{
    for (SPPlayerInvertoryItemTag *tag in self.tags) {
        if ( !_rarityTag && [tag.category isEqualToString:kSPPlayerItemRarityTag]) {
            _rarityTag = tag;
        }
        else if (!_heroTag && [tag.category isEqualToString:kSPPlayerItemHeroTag]){
            _heroTag = tag;
        }
        else if (!_typeTag && [tag.category isEqualToString:kSPPlayerItemTypeTag]){
            _typeTag = tag;
        }
        else if (!_qualityTag && [tag.category isEqualToString:kSPPlayerItemQualityTag]){
            _qualityTag = tag;
        }
        else if (!_slotTag && [tag.category isEqualToString:kSPPlayerItemSlotTag]){
            _slotTag = tag;
        }
    }
}

YYModelDefaultCode
@end

@implementation SPPlayerInventoryItemDesc
YYModelDefaultCode

@end

@implementation SPPlayerInvertoryItemTag

+ (NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"tagColor"];
}

- (SPItemColor *)tagColor
{
    if (!_tagColor) {
        _tagColor = [SPItemColor new];
        _tagColor.hex_color = self.color;
    }
    return _tagColor;
}

YYModelDefaultCode
@end
