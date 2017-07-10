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
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    NSDictionary *rgInventory = dic[@"rgInventory"];
    NSDictionary *rgDescriptions = dic[@"rgDescriptions"];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *aItem in [rgInventory allValues]) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:aItem];
        NSString *k = [NSString stringWithFormat:@"%@_%@",tmp[@"classid"],tmp[@"instanceid"]];
        NSDictionary *rgDescriptionDict = rgDescriptions[k];
        if (!rgDescriptionDict) {
            // 这里需要考虑多页的情况。如果多页的条件下 k 对应的 rgDescription 在其他页，就需要重写了。
            NSLog(@"123123123");
        }else{
            [tmp addEntriesFromDictionary:rgDescriptionDict];
        }
        
        [items addObject:tmp];
    }
    
    [items sortUsingComparator:^NSComparisonResult(NSDictionary *obj1,NSDictionary *obj2) {
        NSUInteger pos1 = [obj1[@"pos"] integerValue];
        NSUInteger pos2 = [obj2[@"pos"] integerValue];
        return [@(pos1) compare:@(pos2)];
    }];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dic];
    mDict[@"items"] = items;
    mDict[@"rgInventory"] = nil;
    mDict[@"rgDescriptions"] = nil;
    return mDict;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"items":[SPPlayerItemDetail class]};
}

YYModelDefaultCode
@end

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

- (SPPlayerInvertoryItemTag *)tagOfName:(NSString *)name
{
    if (!name) return nil;
    for (SPPlayerInvertoryItemTag *tag in self.tags) {
        if ([tag.category isEqualToString:name]) {
            return tag;
        }
    }
    return nil;
}

- (SPPlayerInvertoryItemTag *)rarityTag
{
    if (!_rarityTag) {
        _rarityTag = [self tagOfName:@"Rarity"];
    }
    return _rarityTag;
}

- (SPPlayerInvertoryItemTag *)heroTag
{
    if (!_heroTag) {
        _heroTag = [self tagOfName:@"Hero"];
    }
    return _heroTag;
}

- (SPPlayerInvertoryItemTag *)typeTag
{
    if (!_typeTag) {
        _typeTag = [self tagOfName:@"Type"];
    }
    return _typeTag;
}

- (SPPlayerInvertoryItemTag *)qualityTag
{
    if (!_qualityTag) {
        _qualityTag = [self tagOfName:@"Quality"];
    }
    return _qualityTag;
}

- (SPPlayerInvertoryItemTag *)slotTag
{
    if (!_slotTag) {
        _slotTag = [self tagOfName:@"Slot"];
    }
    return _slotTag;
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
