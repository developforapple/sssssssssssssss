//
//  SPItemGameData.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemGameData.h"
#import "SPLocalMapping.h"
#import <YYModel.h>
#import <FMDB.h>
#import "VDFParser.h"
#import "SPLootList.h"
#import "SPItemSlot.h"
#import "SPDotaEvent.h"
#import "SPPathManager.h"
#import <SSZipArchive.h>
#import "SPLogHelper.h"

#define FileManager [NSFileManager defaultManager]

static NSString *pwd = @"wwwbbat.DOTA2.19880920";

@interface SPItemGameModel ()
- (BOOL)createItems:(VDFNode *)data;
- (BOOL)createRarities:(VDFNode *)data;
- (BOOL)createPrefabs:(VDFNode *)data;
- (BOOL)createQualities:(VDFNode *)data;
- (BOOL)createHeroes;
- (BOOL)createEvents;
- (BOOL)createColors:(VDFNode *)data;
- (BOOL)createSlots:(VDFNode *)data;
- (BOOL)createLootList:(VDFNode *)lootList;
- (BOOL)createItemSets:(VDFNode *)sets;
@end

@implementation SPItemGameData

+ (instancetype)shared
{
    static SPItemGameData *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPItemGameData new];
        shared.model = [SPItemGameModel new];
    });
    return shared;
}

- (BOOL)dataWithRootNode:(VDFNode *)root
{
    // hero
    BOOL a = [self.model createHeroes];
    
    // events
    BOOL b = a && [self.model createEvents];
    
    VDFNode *rarities = [root firstChildWithKey:@"rarities"];
    BOOL c = b && [self.model createRarities:rarities];
    
    VDFNode *qualities = [root firstChildWithKey:@"qualities"];
    BOOL d = c && [self.model createQualities:qualities];
    
    VDFNode *colors = [root firstChildWithKey:@"colors"];
    BOOL e = d && [self.model createColors:colors];
    
    VDFNode *slots = [root firstChildWithKey:@"player_loadout_slots"];
    BOOL f = e && [self.model createSlots:slots];
    
    VDFNode *prefabs = [root firstChildWithKey:@"prefabs"];
    BOOL g = f && [self.model createPrefabs:prefabs];
    
    VDFNode *item_sets = [root firstChildWithKey:@"item_sets"];
    BOOL h = g && [self.model createItemSets:item_sets];
    
    VDFNode *loot_lists = [root firstChildWithKey:@"loot_lists"];
    BOOL i = h && [self.model createLootList:loot_lists];
    
    VDFNode *items = [root firstChildWithKey:@"items"];
    BOOL j = i && [self.model createItems:items];
    
    return j;
}

@end

@implementation SPItemGameModel

// Done

- (BOOL)createHeroes
{
    SPLog(@"正在生成英雄列表");
    
    NSString *heroPath = @"/Applications/SteamLibrary/SteamApps/common/dota 2 beta/game/dota/scripts/npc/npc_heroes.txt";
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:heroPath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (error) {
        SPLog(@"读取英雄列表文件失败: %@",error);
        return NO;
    }
    
    VDFNode *root = [VDFParser parse:data];
    VDFNode *node = [root firstChildWithKey:@"DOTAHeroes"];
    
    NSArray *heroes = node.children;
    
    NSMutableArray *heroArray = [NSMutableArray array];
    for (VDFNode *aHeroNode in heroes) {
        
        NSString *name = aHeroNode.k;
        
        if ([name isEqualToString:@"npc_dota_hero_base"] ||
            [name isEqualToString:@"npc_dota_hero_target_dummy"]) continue;
        
        SPHero *aHero = [SPHero hero:name Node:aHeroNode];
        if (aHero) {
            [heroArray addObject:aHero];
        }else{
            SPLog(@"读取一个英雄出错了：%@",name);
            return NO;
        }
    }
    SPLog(@"创建英雄列表完成，共%d个英雄",heroArray.count);
    self.heroes = heroArray;
    return YES;
}

- (BOOL)createEvents
{
    // 先生成各种事件。所有事件类型在一个特殊的文件中 名字为 event_definitions.txt 需要打开
    // 在下一步中 会将有 event_id 字段的饰品，从事件列表中查找本地字符串。如果没找到，出现警告：“有新的事件类型” 表示事件文件需要更新
    // 在windows下打开游戏原始文件，提取出 event_definitions.txt 覆盖应用中的文件。重新运行程序。
    
    SPLog(@"正在创建事件列表");
    NSArray *eventArray =
    @[@{@"id":@3,   @"event_id":@"EVENT_ID_INTERNATIONAL_2017",     @"event_name":@"DOTA_EventName_International2017", @"image_name":@"TI7"},
      @{@"id":@2,   @"event_id":@"EVENT_ID_INTERNATIONAL_2016",     @"event_name":@"DOTA_EventName_International2016", @"image_name":@"TI6"},
      @{@"id":@1,   @"event_id":@"EVENT_ID_INTERNATIONAL_2015",     @"event_name":@"DOTA_EventName_International2015", @"image_name":@"TI5"},
      @{@"id":@0,   @"event_id":@"EVENT_ID_COMPENDIUM_2014",        @"event_name":@"DOTA_EventName_International2014", @"image_name":@"TI4"},
      @{@"id":@7,   @"event_id":@"EVENT_ID_WINTER_MAJOR_2017",      @"event_name":@"DOTA_EventName_WinterMajor2017"  , @"image_name":@"winter_2017"},
      @{@"id":@8,   @"event_id":@"EVENT_ID_NEW_BLOOM_2017",         @"event_name":@"DOTA_EventName_NewBloom2017"     , @"image_name":@"new_bloom_2017"},
      @{@"id":@6,   @"event_id":@"EVENT_ID_WINTER_MAJOR_2016",      @"event_name":@"DOTA_EventName_WinterMajor2016"  , @"image_name":@"winter_2016"},
      @{@"id":@5,   @"event_id":@"EVENT_ID_FALL_MAJOR_2016",        @"event_name":@"DOTA_EventName_FallMajor2016"    , @"image_name":@"fall_2016"},
      @{@"id":@4,   @"event_id":@"EVENT_ID_FALL_MAJOR_2015",        @"event_name":@"DOTA_EventName_FallMajor2015"    , @"image_name":@"frankfut_major_2015"},
      @{@"id":@9,   @"event_id":@"EVENT_ID_NEXON_PC_BANG",          @"event_name":@"NEXON PC BANG"                   , @"image_name":@"nexon_pc_bang"},
      @{@"id":@10,  @"event_id":@"EVENT_ID_PWRD_DAC_2015",          @"event_name":@"PWRD DAC 2015"                   , @"image_name":@"dac_2015"},];
    NSArray *events = [NSArray yy_modelArrayWithClass:[SPDotaEvent class] json:eventArray];
    self.events = events;
    SPLog(@"创建事件列表完成：数量：%d",events.count);
    return YES;
}

- (BOOL)createRarities:(VDFNode *)data
{
    SPLog(@"正在生成稀有度列表");
    NSArray *rarities = [SPItemRarity raritiesWithArray:data.children];
    SPLog(@"生成稀有度列表完成，数量：%d",rarities.count);
    self.rarities = rarities;
    return YES;
}

- (BOOL)createQualities:(VDFNode *)data
{
    SPLog(@"正在生成前缀列表");
    NSArray *qualities = [SPItemQuality qualitiesWithArray:data.children];
    SPLog(@"生成前缀列表完成，数量：%d",qualities.count);
    self.qualities = qualities;
    return YES;
}

- (BOOL)createColors:(VDFNode *)data
{
    SPLog(@"正在生成颜色列表");
    NSArray *colors = [SPItemColor colorsFromArray:data.children];
    SPLog(@"生成颜色列表完成，数量：%d",colors.count);
    self.colors = colors;
    return YES;
}

- (BOOL)createSlots:(VDFNode *)data
{
    SPLog(@"正在生成槽位列表");
    NSArray *slots = [SPItemSlot loadoutSlots:data];
    SPLog(@"生成槽位列表完成，数量：%d",slots.count);
    self.slots = slots;
    return YES;
}

- (BOOL)createPrefabs:(VDFNode *)data
{
    SPLog(@"正在生成饰品类型列表");
    NSArray *prefabs = [SPItemPrefab prefabsWithArray:data.children];
    SPLog(@"生成饰品类型列表完成，数量：%d",prefabs.count);
    self.prefabs = prefabs;
    return YES;
}

- (BOOL)createItemSets:(VDFNode *)data
{
    SPLog(@"正在生成包列表");
    NSArray *itemSets = [SPItemSets itemSets:data.children];
    
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    for (SPItemSets *aItemSet in itemSets) {
        for (NSString *aItemName in aItemSet.items) {
            
            NSMutableSet *set = mapping[aItemName];
            if (!set) {
                set = [NSMutableSet set];
                mapping[aItemName] = set;
            }
            [set addObject:aItemSet.store_bundle];
        }
    }
    self.item_sets = itemSets;
    self.item_sets_map = mapping;
    
    SPLog(@"生成包列表完成，共%d个包",(int)itemSets.count);
    SPLog(@"生成饰品-包映射完成，共%d条映射",(int)mapping.count);
    return YES;
}

- (BOOL)createLootList:(VDFNode *)data
{
    SPLog(@"正在生成掉落列表");
    NSArray *lootList = [SPLootList lootList:data.children];
    self.loot_list = lootList;
    return YES;
}

- (BOOL)createItems:(VDFNode *)data
{
    SPLog(@"正在创建饰品列表");
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *nodes = data.children;
    for (VDFNode *aNode in nodes) {
        NSString *identifier = aNode.k;
        NSMutableDictionary *v = [aNode allDict];
        NSUInteger theId = [identifier integerValue];
        if (theId >= 1000) {
            v[@"token"] = @(theId);
            [array addObject:v];
        }
    }
    
    NSArray *entities = [NSArray yy_modelArrayWithClass:[SPItem class] json:array];
    self.items = entities;
    
    SPLog(@"生成%d个饰品",(int)entities.count);
    
    for (SPItem *item in self.items) {
        if (item.event_id && ![item.event_id isEqualToString:@"EVENT_ID_NONE"]) {
            
            SPDotaEvent *event;
            for (SPDotaEvent *aEvent in self.events) {
                if ([aEvent.event_id isEqualToString:item.event_id]) {
                    event = aEvent;
                    break;
                }
            }
            if (!event) {
                SPLog(@"有未知的事件");
            }else{
                item.event_id = event.event_id;
            }
        }
        
        // 饰品所属捆绑包
        NSString *name = item.name;
        NSSet *set = self.item_sets_map[[name lowercaseString]];
        if (set) {
            item.bundles = [[set allObjects] componentsJoinedByString:@"||"];
        }
    }
    SPLog(@"生成饰品列表完成");
    return YES;
}


- (void )saveItemToDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self tmpDBPath]];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE items (token integer PRIMARY KEY,\
                                             creation_date text,\
                                             image_inventory text,\
                                             item_description text,\
                                             item_name text,\
                                             item_rarity text,\
                                             name text,\
                                             prefab text,\
                                             item_type_name text,\
                                             image_banner text,\
                                             tournament_url text,\
                                             item_slot text,\
                                             item_quality text,\
                                             prpt text,\
                                             proli text,\
                                             prpot text,\
                                             prpoe text,\
                                             pte text,\
                                             oaa text,\
                                             event_id text,\
                                             expiration_date text,\
                                             player_loadout text,\
                                             associated_item text,\
                                             item_class text,\
                                             autograph text,\
                                             heroes text,\
                                             bundleItems text,\
                                             lootlist text,\
                                             bundles text,\
                                             styles text,\
                                             hidden text\
                                            )"];
    NSString *sqlite = @"INSERT INTO items (token,creation_date,image_inventory,item_description,item_name,item_rarity,name,prefab,item_type_name,image_banner,tournament_url,item_slot,item_quality,prpt,proli,prpot,prpoe,pte,oaa,event_id,expiration_date,player_loadout,associated_item,item_class,autograph,heroes,bundleItems,lootlist,bundles,styles,hidden)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    for (SPItem *item in self.items) {
        
        [db executeUpdate:sqlite,    item.token,
                                     item.creation_date?:@"",
                                     item.image_inventory?:@"",
                                     item.item_description?:@"",
                                     item.item_name?:@"",
                                     item.item_rarity?:@"",
                                     item.name?:@"",
                                     item.prefab?:@"",
                                     item.item_type_name?:@"",
                                     item.image_banner?:@"",
                                     item.tournament_url?:@"",
                                     item.item_slot?:@"",
                                     item.item_quality?:@"",
                                     item.purchase_requirement_prompt_text?:@"",
                                     item.purchase_requires_owning_league_id?:@"",
                                     item.purchase_requirement_prompt_ok_text?:@"",
                                     item.purchase_requirement_prompt_ok_event?:@"",
                                     item.purchase_through_event?:@"",
                                     item.override_attack_attachments?:@"",
                                     item.event_id?:@"",
                                     item.expiration_date?:@"",
                                     item.player_loadout?:@"",
                                     item.associated_item?:@"",
                                     item.item_class?:@"",
                                     item.autograph?:@0,
                                     item.heroes?:@"",
                                     item.bundleItems?:@"",
                                     item.lootList?:@"",
                                     item.bundles?:@"",
                                     item.stylesString?:@"",
                                     item.hidden?:@""];
    }    
    [db close];
}

- (void)saveItemSetsToDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self tmpDBPath]];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE sets (token text,\
                                            name text,\
                                            store_bundle text,\
                                            items text)"];
    
    NSString *sql = @"INSERT INTO sets (token,name,store_bundle,items)VALUES(?,?,?,?)";
    for (SPItemSets *sets in self.item_sets) {
        
        [db executeUpdate:sql,  sets.token,
                                sets.name,
                                sets.store_bundle?:@"",
                                [sets.items componentsJoinedByString:@"||"]?:@""];
        
    }
    [db close];
}

- (void)saveJSONData
{
    id rarities = [self.rarities yy_modelToJSONObject];
    id prefabs = [self.prefabs yy_modelToJSONObject];
    id quelities = [self.qualities yy_modelToJSONObject];
    id heroes = [self.heroes yy_modelToJSONObject];
    id slots = [self.slots yy_modelToJSONObject];
    id colors = [self.colors yy_modelToJSONObject];
    id lootlist = [self.loot_list yy_modelToJSONObject];
    id events = [self.events yy_modelToJSONObject];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"rarities"] = rarities;
    dict[@"prefabs"] = prefabs;
    dict[@"qualities"] = quelities;
    dict[@"heroes"] = heroes;
    dict[@"slots"] = slots;
    dict[@"colors"] = colors;
    dict[@"lootlist"] = lootlist;
    dict[@"events"] = events;
    
    SPLog(@"创建jsonData");
    self.jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *path = [self jsondataPath];
    [FileManager removeItemAtPath:path error:nil];
    BOOL suc = [self.jsonData writeToFile:path atomically:YES];
    SPLog(@"jsonData 保存完成！");
}

- (NSString *)versionPath
{
    return [[SPPathManager baseDataPath] stringByAppendingPathComponent:@"base_data_version.txt"];
}

- (NSDictionary *)version
{
    NSString *path = [self versionPath];
    if ([FileManager fileExistsAtPath:path]) {
        return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
    }else{
        return @{};
    }
}

- (void)saveVersion:(NSDictionary *)version
{
    NSString *path = [self versionPath];
    [FileManager removeItemAtPath:path error:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:version options:kNilOptions error:nil];
    [data writeToFile:path atomically:YES];
    SPLog(@"保存版本文件完成");
}

- (BOOL)save
{
    [FileManager removeItemAtPath:[self tmpDBPath] error:nil];

    [self saveItemToDB];
    [self saveItemSetsToDB];
    [self saveJSONData];
    
    long long lastVersion = [[self version][@"version"] longLongValue];
    long long thisVersion = [[NSDate date] timeIntervalSince1970] * 1000 - kMagicNumber;
    
    NSString *archivePath;
    if ([FileManager fileExistsAtPath:self.dbPath]) {
        archivePath = [[SPPathManager baseDataPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"item_%lld.db",lastVersion]];
        [FileManager moveItemAtPath:self.dbPath toPath:archivePath error:nil];
    }
    
    NSError *error;
    BOOL suc = [FileManager moveItemAtPath:[self tmpDBPath] toPath:[self dbPath] error:&error];
    if (!suc || error) {
        SPLog(@"保存出错！");
        return NO;
    }
    
    SPLog(@"开始计算更新的内容");
    [self calculateDif:archivePath];
    
    // 删除旧文件
    if (archivePath) {
        [FileManager removeItemAtPath:archivePath error:nil];
    }
    
    [self saveVersion:@{@"version":@(thisVersion)}];
    SPLog(@"数据更新完成，版本：%lld",thisVersion);
    
    BOOL a = [self createZipFile];
    return a;
}

- (void)calculateDif:(NSString *)archivePath
{
    NSMutableArray *add = [NSMutableArray array];
    NSMutableArray *modify = [NSMutableArray array];
    
    if (archivePath){
        // 比较archivePath 的db 和 dbPath 的db 的差异
        NSMutableSet *oldTokens = [NSMutableSet set];
        {
            FMDatabase *oldDB = [FMDatabase databaseWithPath:archivePath];
            [oldDB open];
            FMResultSet *result = [oldDB executeQuery:@"SELECT token FROM items"];
            int index = [result columnIndexForName:@"token"];
            while ([result next]) {
                [oldTokens addObject:[result stringForColumnIndex:index]];
            }
            [oldDB close];
        }
        
        NSMutableSet *langChangeKeys = [NSMutableSet set];
        {
            long long v = [[SPLocalMapping langVersion][[NSString stringWithFormat:@"%@_patch",kSPLanguageSchinese]] longLongValue];
            NSString *path = [SPLocalMapping changeLogFilePath:kSPLanguageSchinese version:v];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                NSArray *_add = dict[@"add"];
                NSArray *_modify = dict[@"modify"];
                [langChangeKeys addObjectsFromArray:_add];
                [langChangeKeys addObjectsFromArray:_modify];
            }
        }
        
        {
            FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
            [db open];
            FMResultSet *result = [db executeQuery:@"SELECT token,item_description,item_name,item_type_name FROM items"];
            int tokenIndex = [result columnIndexForName:@"token"];
            int descIndex = [result columnIndexForName:@"item_description"];
            int nameIndex = [result columnIndexForName:@"item_name"];
            int typeIndex = [result columnIndexForName:@"item_type_name"];
            while ([result next]) {
                NSString *token = [result stringForColumnIndex:tokenIndex];
                BOOL isNew = ![oldTokens containsObject:token];
                if (isNew) {
                    // 新饰品
                    [add addObject:token];
                    continue;
                }
                //旧饰品
                {
                    NSString *text = [result stringForColumnIndex:descIndex];
                    if (![text isKindOfClass:[NSNull class]] &&
                        text.length > 0 &&
                        [text hasPrefix:@"#"]) {
                        
                        NSString *str = [[text substringFromIndex:1] lowercaseString];
                        if ([langChangeKeys containsObject:str]) {
                            //修改了描述
                            [modify addObject:str];
                            continue;
                        }
                    }
                }
                {
                    NSString *text = [result stringForColumnIndex:nameIndex];
                    if (![text isKindOfClass:[NSNull class]] &&
                        text.length > 0 &&
                        [text hasPrefix:@"#"]) {
                        NSString *str = [[text substringFromIndex:1] lowercaseString];
                        if ([langChangeKeys containsObject:str]) {
                            //修改了名称
                            [modify addObject:str];
                            continue;
                        }
                    }
                }
                {
                    NSString *text = [result stringForColumnIndex:typeIndex];
                    if (![text isKindOfClass:[NSNull class]] &&
                        text.length > 0 &&
                        [text hasPrefix:@"#"]) {
                        NSString *str = [[text substringFromIndex:1] lowercaseString];
                        if ([langChangeKeys containsObject:str]) {
                            //修改了名称
                            [modify addObject:str];
                            continue;
                        }
                    }
                }
            }
        }
    }
    
    NSDictionary *change = @{@"add":add,@"modify":modify};
    NSData *data = [NSJSONSerialization dataWithJSONObject:change options:kNilOptions error:nil];
    NSString *path = [self changeLogPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [data writeToFile:path atomically:YES];
    self.addCount = add.count;
    self.modifyCount = modify.count;
}

- (NSString *)jsondataPath
{
    return [[SPPathManager baseDataPath] stringByAppendingPathComponent:@"data.json"];
}

- (NSString *)dbPath
{
    return [[SPPathManager baseDataPath] stringByAppendingPathComponent:@"item.db"];
}

- (NSString *)tmpDBPath
{
    return [[SPPathManager baseDataPath] stringByAppendingPathComponent:@"item_tmp.db"];
}

- (NSString *)changeLogPath
{
    return [[SPPathManager baseDataPath] stringByAppendingPathComponent:@"change.json"];
}

- (NSString *)zipFilePath
{
    NSNumber *v = [self version][@"version"];
    NSString *zipPath = [[SPPathManager baseDataPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"base_data_%@.zip",v]];
    return zipPath;
}

- (BOOL)createZipFile
{
    NSString *zipPath = [self zipFilePath];
    [FileManager removeItemAtPath:zipPath error:nil];
    BOOL suc = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:@[[self jsondataPath],[self dbPath],[self changeLogPath]] withPassword:pwd];
    if (!suc) {
        SPLog(@"创建压缩文件失败！");
        return NO;
    }
    return YES;
}

- (void)fetchItemImageInventory:(SPItem *)item
{
    // TODO 这里要做容错处理
    
    static BOOL keyFlag = NO;
    
    // 图片
    NSString *image_inventory = item.image_inventory;                       // econ/cursor_pack/ti5_cursor_pack
    NSString *image_inventroy_name = [image_inventory lastPathComponent];   // ti5_cursor_pack
    
    NSString *key = keyFlag?@"CD9010FD71FA1583192F9BDB87ED8164":@"D46675A241E560655ABD306C2A275D60";
    keyFlag = !keyFlag;
    
    NSString *normalReqeustURL = [NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1?key=%@&iconname=%@&icontype=0",key,image_inventroy_name];
    NSString *largeReqeustURL = [NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1?key=%@&iconname=%@&icontype=1",key,image_inventroy_name];
    
    
    NSData *normalResult = [NSData dataWithContentsOfURL:[NSURL URLWithString:normalReqeustURL]];
    NSData *largeResult = [NSData dataWithContentsOfURL:[NSURL URLWithString:largeReqeustURL]];
    
    NSError *error;
    
    NSDictionary *normalJSON = [NSJSONSerialization JSONObjectWithData:normalResult options:kNilOptions error:&error];
    
    if (error) {
        SPLog(@"%@ 普通图片获取出错",item.token);
    }
    
    NSDictionary *largeJSON = [NSJSONSerialization JSONObjectWithData:largeResult options:kNilOptions error:&error];
    
    if (error) {
        SPLog(@"%@ 大图片获取出错",item.token);
    }
    
    NSString *normalImagePath = normalJSON[@"result"][@"path"];
    NSString *largeImagePath = largeJSON[@"result"][@"path"];
    
    
    if (normalImagePath) {
        NSString *normalImageURL = [@"http://cdn.dota2.com/apps/570" stringByAppendingPathComponent:normalImagePath];
        item.image_inventory = normalImageURL;
        
    }
    if (largeImagePath) {
        NSString *largeImageURL = [@"http://cdn.dota2.com/apps/570" stringByAppendingPathComponent:largeImagePath];
        item.image_inventory_large = largeImageURL;
    }
    
    // image_banner
    NSString *image_banner = item.image_banner;
    if (image_banner.length > 0) {
        NSString *bannerRequestURL;
        if ([image_banner hasSuffix:@"ingame"]) {
            bannerRequestURL = [NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1?key=%@&iconname=%@&icontype=2",key,image_inventroy_name];
        }else{
            NSString *image_banner_name = [image_banner lastPathComponent];
            bannerRequestURL = [NSString stringWithFormat:@"https://api.steampowered.com/IEconDOTA2_570/GetItemIconPath/v1?key=%@&iconname=%@",key,image_banner_name];
        }
        NSData *bannerResult = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerRequestURL]];
        NSDictionary *bannerJSON = [NSJSONSerialization JSONObjectWithData:bannerResult options:kNilOptions error:nil];
        NSString *image_banner_url = bannerJSON[@"result"][@"path"];
        
        item.image_banner = image_banner_url;
    }
}

@end
