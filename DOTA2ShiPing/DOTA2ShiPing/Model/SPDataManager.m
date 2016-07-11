//
//  SPDataManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPDataManager.h"
#import "YYModel.h"

@interface SPDataManager ()
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation SPDataManager

+ (instancetype)shared
{
    static SPDataManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPDataManager new];
        
        [shared loadTestData];
    });
    return shared;
}

- (void)loadTestData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    self.heroes = [NSArray yy_modelArrayWithClass:[SPHero class] json:dict[@"heroes"]];
    self.prefabs = [NSArray yy_modelArrayWithClass:[SPItemPrefab class] json:dict[@"prefabs"]];
    self.rarities = [NSArray yy_modelArrayWithClass:[SPItemRarity class] json:dict[@"rarities"]];
    self.colors = [NSArray yy_modelArrayWithClass:[SPItemColor class] json:dict[@"colors"]];
    self.qualities = [NSArray yy_modelArrayWithClass:[SPItemQuality class] json:dict[@"qualities"]];
}

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
        if ([color.token isEqualToString:name]) {
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
            names = @[@"ward",@"weather",@"terrain",@"summons"];
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
            names = @[@"blink_effect",@"tool",@"emoticon_tool",@"player_card",@"teleport_effect",@"misc",@"dynamic_recipe",@"league",@"passport_fantasy_team",@"socket_gem",@"taunt"];
            break;
        default:
            break;
    }
    return [self prefabsOfNames:names];
}

#pragma mark - db
- (FMDatabase *)db
{
    if (!_db) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"db"];
        _db = [FMDatabase databaseWithPath:path];
    }
    [_db open];
    return _db;
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
        [array addObject:sets];
    }
    return array;
}

@end
