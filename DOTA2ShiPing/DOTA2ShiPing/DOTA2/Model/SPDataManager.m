//
//  SPDataManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPDataManager.h"
#import "YYModel.h"
#import "SPBaseData.h"

@interface SPDataManager ()
@property (strong, readwrite, nonatomic) NSDictionary<NSString *,NSString *> *localMap;
@property (strong, readwrite, nonatomic) NSArray<SPHero *> *heroes;
@property (strong, readwrite, nonatomic) NSArray<SPItemPrefab *> *prefabs;
@property (strong, readwrite, nonatomic) NSArray<SPItemRarity *> *rarities;
@property (strong, readwrite, nonatomic) NSArray<SPItemColor *> *colors;
@property (strong, readwrite, nonatomic) NSArray<SPItemQuality *> *qualities;
@property (strong, readwrite, nonatomic) NSArray<SPItemSlot *> *slots;
@property (strong, readwrite, nonatomic) NSArray<SPLootList *> *lootlist;
@property (strong, readwrite, nonatomic) NSArray<SPDotaEvent *> *events;
@property (strong, readwrite, nonatomic) FMDatabase *db;

@property (strong, nonatomic) NSSet *lootlistTokens;

@end

@implementation SPDataManager

+ (instancetype)shared
{
    static SPDataManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPDataManager new];
        [shared reloadData];
    });
    return shared;
}

#pragma mark - Reload
- (void)reloadData
{
    [self reloadLocalMap];
    [self reloadItemBaseData];
    [self reloadDB];
}

- (void)reloadLocalMap
{
    NSString *lang = GetLang;
    NSString *langMainFile = [SPBaseData langMainFilePath:lang];
    NSString *langPatchFile = [SPBaseData langPatchFilePath:lang];
    
    NSError *error;
    
    NSInputStream *langMainStream = [NSInputStream inputStreamWithFileAtPath:langMainFile];
    [langMainStream open];
    NSMutableDictionary *langMainMap = [NSJSONSerialization JSONObjectWithStream:langMainStream options:NSJSONReadingMutableContainers error:&error];
    [langMainStream close];
    NSAssert(!error, @"出错了！");
    
    NSInputStream *langPatchStream = [NSInputStream inputStreamWithFileAtPath:langPatchFile];
    [langPatchStream open];
    NSDictionary *langPatchMap = [NSJSONSerialization JSONObjectWithStream:langPatchStream options:kNilOptions error:&error];
    [langPatchStream close];
    NSAssert(!error, @"出错了！");
    
    [langMainMap addEntriesFromDictionary:langPatchMap];
    self.localMap = langMainMap;
}

- (void)reloadItemBaseData
{
    NSError *error;
    NSString *path = [SPBaseData dataPath];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:&error];
    NSAssert(!error, @"出错了！");
    
    NSArray<SPItemRarity *> *rarities  = [NSArray yy_modelArrayWithClass:[SPItemRarity class] json:info[@"rarities"]];
    NSArray<SPItemPrefab *> *prefabs   = [NSArray yy_modelArrayWithClass:[SPItemPrefab class] json:info[@"prefabs"]];
    NSArray<SPItemColor *>  *colors    = [NSArray yy_modelArrayWithClass:[SPItemColor class] json:info[@"colors"]];
    NSArray<SPItemQuality*> *qualities = [NSArray yy_modelArrayWithClass:[SPItemQuality class] json:info[@"qualities"]];
    NSArray<SPHero *>       *heroes    = [NSArray yy_modelArrayWithClass:[SPHero class] json:info[@"heroes"]];
    NSArray<SPItemSlot *>   *slots     = [NSArray yy_modelArrayWithClass:[SPItemSlot class] json:info[@"slots"]];
    NSArray<SPLootList *>   *lootlist  = [NSArray yy_modelArrayWithClass:[SPLootList class] json:info[@"lootlist"]];
    NSArray<SPDotaEvent *>  *events    = [NSArray yy_modelArrayWithClass:[SPDotaEvent class] json:info[@"events"]];
    
    for (SPHero *aHero in heroes) {
        [aHero setName_loc: [self localizedString:aHero.name] ?: (aHero.name) ];
        for (SPItemSlot *aSlot in aHero.ItemSlots) {
            // 这个本地化名称根据英雄的不同，会不同。
            [aSlot setName_loc:[self localizedString:aSlot.SlotText] ? : aSlot.SlotText ];
        }
    }
    self.heroes = [heroes sortedArrayUsingComparator:^NSComparisonResult(SPHero *obj1, SPHero *obj2) {
        NSInteger heroID1 = obj1.HeroID.integerValue;
        NSInteger heroID2 = obj2.HeroID.integerValue;
        return heroID1 < heroID2 ? NSOrderedAscending : (heroID1 == heroID2 ? NSOrderedSame : NSOrderedDescending) ;
    }];
    
    for (SPItemPrefab *aPrefab in prefabs) {
        NSString *loc = [self localizedString:aPrefab.name];
        if (!loc) {
            loc = [self localizedString:aPrefab.item_type_name];
        }
        if (!loc) {
            loc = aPrefab.name;
        }
        [aPrefab setName_loc:loc];
    }
    
    for (SPItemQuality *aQuality in qualities) {
        [aQuality setName_loc:[self localizedString:aQuality.displayName] ? : aQuality.name];
    }
    
    for (SPItemRarity *aRarity in rarities) {
        [aRarity setName_loc:[self localizedString:aRarity.loc_key] ? : aRarity.name];
    }
    
    for (SPItemSlot *aSlot in slots) {
        [aSlot setName_loc:[self localizedString:aSlot.SlotText] ? : aSlot.SlotName];
    }
    
    NSMutableSet *lootlistTokens = [NSMutableSet set];
    for (SPLootList *aList in lootlist) {
        [lootlistTokens addObject:aList.token];
    }
    
    for (SPDotaEvent *aEvent in events) {
        aEvent.name_loc = [self localizedString:aEvent.event_name];
    }
    
    self.rarities = rarities;
    self.prefabs = prefabs;
    self.colors = colors;
    self.qualities = qualities;
    self.slots = slots;
    self.lootlist = lootlist;
    self.lootlistTokens = lootlistTokens;
    self.events = events;
}

- (void)reloadDB
{
    NSString *path = [SPBaseData dbPath];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
}

#pragma mark - Other
- (SPItemRarity *)rarityOfName:(NSString *)name
{
    if (!name) return nil;
    NSString *tmp = [name lowercaseString];
    for (SPItemRarity *rarity in self.rarities) {
        if ([rarity.name isEqualToString:tmp]) {
            return rarity;
        }
    }
    return nil;
}

- (SPItemColor *)colorOfName:(NSString *)name
{
    if (!name) return nil;
    for (SPItemColor *color in self.colors) {
        if ([color.name isEqualToString:name]) {
            return color;
        }
    }
    return nil;
}

- (SPItemPrefab *)prefabOfName:(NSString *)name
{
    if (!name) return nil;
    return [[self prefabsOfNames:@[name]] firstObject];
}

- (NSArray<SPItemPrefab *> *)prefabsOfNames:(NSArray<NSString *> *)names
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *name in names) {
        for (SPItemPrefab *prefab in self.prefabs) {
            if ([prefab.name isEqualToString:name]) {
                [array addObject:prefab];
            }
        }
    }
    return array;
}

- (NSArray<SPItemPrefab *> *)prefabsOfEntranceType:(SPItemEntranceType)type
{
    NSArray *names;
    switch (type) {
        case SPItemEntranceTypeCourier:
            names = @[@"courier",@"courier_wearable",@"modifier"];
            break;
        case SPItemEntranceTypeWorld:
            names = @[@"ward",@"weather",@"terrain",@"summons",@"relic",@"teleport_effect",@"blink_effect"];
            break;
        case SPItemEntranceTypeHud:
            names = @[@"cursor_pack",@"hud_skin",@"loading_screen",@"pennant"];
            break;
        case SPItemEntranceTypeAudio:
            names = @[@"music",@"announcer"];
            break;
        case SPItemEntranceTypeTreasure:
            names = @[@"treasure_chest",@"retired_treasure_chest",@"key"];
            break;
        case SPItemEntranceTypeOther:
            names = @[@"tool",@"taunt",@"emoticon_tool",@"player_card",@"misc",@"dynamic_recipe",@"league",@"passport_fantasy_team",@"socket_gem",@"bundle"];
            break;
        default:
            break;
    }
    return [self prefabsOfNames:names];
}

- (NSArray<SPHero *> *)heroesOfNames:(NSArray<NSString *> *)heroes
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in heroes) {
        for (SPHero *aHero in self.heroes) {
            if ([aHero.name isEqualToString:name]) {
                [array addObject:aHero];
            }
        }
    }
    return array;
}

- (SPItemQuality *)qualityOfName:(NSString *)name
{
    if (!name) return nil;
    for (SPItemQuality *quality in self.qualities) {
        if ([quality.name isEqualToString:name]) {
            return quality;
        }
    }
    return nil;
}

- (SPItemSlot *)slotOfName:(NSString *)name
{
    if (!name) return nil;
    for (SPItemSlot *slot in self.slots) {
        if ([slot.SlotName isEqualToString:name]) {
            return slot;
        }
    }
    return nil;
}

- (NSArray<SPItemSets *> *)querySetsWithCondition:(NSString *)condition values:(NSArray *)values
{
    if (condition.length == 0) {
        return @[];
    }
    
    [self.db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sets WHERE %@",condition];
    
    FMResultSet *result = [self.db executeQuery:sql withArgumentsInArray:values];
    NSMutableArray *array = [NSMutableArray array];
    
    while ([result next]) {
        NSDictionary *dict = [result resultDictionary];
        SPItemSets *sets = [SPItemSets yy_modelWithDictionary:dict];
        sets.name_loc = [self localizedString:sets.name]?:sets.store_bundle;
        [array addObject:sets];
    }
    
    [self.db close];
    
    return array;
}

- (NSArray<NSString *> *)itemsInLootlist:(NSString *)lootlist
{
    if (!lootlist) return nil;
    if (![self.lootlistTokens containsObject:lootlist]) return nil;
    
    SPLootList *list;
    for (SPLootList *aList in self.lootlist) {
        if ([aList.token isEqualToString:lootlist]) {
            list = aList;
            break;
        }
    }
    if (!list) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *aName in list.lootList) {
        NSArray *theList = [self itemsInLootlist:aName];
        if (!theList) {
            [array addObject:aName];
        }else{
            [array addObjectsFromArray:theList];
        }
    }
    
    for (NSString *aName in list.additional) {
        NSArray *theList = [self itemsInLootlist:aName];
        if (!theList) {
            [array addObject:aName];
        }else{
            [array addObjectsFromArray:theList];
        }
    }
    
    return array;
}

@end

@implementation SPDataManager (Local)
- (NSString *)localizedString:(NSString *)token
{
    if (!token) return nil;
    NSString *string = token;
    if ([token hasPrefix:@"#"]) {
        string = [token substringFromIndex:1];
    }
    NSString *lowcaseString = [string lowercaseString];
    NSString *localized =  self.localMap[lowcaseString];
    return localized;
}

@end

@implementation SPDataManager (BaseData)
@end

@implementation SPDataManager (DB)
@end
