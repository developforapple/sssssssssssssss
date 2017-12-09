//
//  SPPlayerManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerManager.h"
#import "SPSteamAPI.h"
#import "FMDB.h"
#import "YYCategories.h"

@interface SPPlayerManager ()
@property (copy, nonatomic) void (^callback)(void);
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation SPPlayerManager

+ (instancetype)shared
{
    static SPPlayerManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPPlayerManager new];
    });
    return shared;
}

#pragma mark - db
- (FMDatabase *)db
{
    if (!_db) {
        _db = [self createDatabaseIfNeed];
        _db.traceExecution = YES;
    }
    return _db;
}

- (FMDatabase *)createDatabaseIfNeed
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dbFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".com.wwwbbat.sp.player"];
    if (![fm fileExistsAtPath:dbFolder]) {
        [fm createDirectoryAtPath:dbFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbPath = [dbFolder stringByAppendingPathComponent:@"player.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS player (steam_id integer PRIMARY KEY,\
                                                           avatar_url text,\
                                                           name text,\
                                                           star integer)"];
    [db close];
    return db;
}

@end

@implementation SPPlayerManager (Star)
- (NSArray<SPPlayer *> *)starredPlayers
{
    [self.db open];
    NSMutableArray *favorites = [NSMutableArray array];
    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM player WHERE star=1"];
    while ([result next]) {
        NSDictionary *dict = [result resultDictionary];
        SPPlayer *player = [SPPlayer yy_modelWithDictionary:dict];
        [favorites addObject:player];
    }
    [result close];
    [self.db close];
    return favorites;
}

- (BOOL)isStarred:(NSNumber *)steamid
{
    if (!steamid) return NO;
    
    [self.db open];
    BOOL isStarred = NO;
    FMResultSet *result = [self.db executeQuery:@"SELECT star FROM player WHERE steam_id=?",steamid];
    if ([result next]) {
        isStarred = [result boolForColumn:@"star"];
    }
    [result close];
    [self.db close];
    return isStarred;
}

- (void)setStarredUpdatedCallback:(void (^)(void))callback
{
    self.callback = callback;
}

- (void)unstarPlayer:(NSNumber *)steamid
{
    if (!steamid) return;
    [self.db open];
    [self.db executeUpdate:@"UPDATE player SET star=0 WHERE steam_id=?",steamid];
    [self callStarredUpdate];
    [self.db close];
}

// 增加星标。只操作已有记录的用户
- (void)starPlayer:(SPPlayer *)player
{
    if (!player) return;
    
    player.star = YES;
    
    NSDictionary *playerDict = [player yy_modelToJSONObject];
    
    [self.db open];
    NSString *sql = @"INSERT OR REPLACE INTO player VALUES(:steam_id,:avatar_url,:name,:star)";
    [self.db executeUpdate:sql withParameterDictionary:playerDict];
    [self callStarredUpdate];
    [self.db close];
}

- (void)callStarredUpdate
{
    if (self.callback) {
        self.callback();
    }
}

@end

#define kDefaultInventoryFileName @"inventory.json.v5"
#define kEigenvalueSaveKey @"SPEigenvalueListv5"

@implementation SPPlayerManager (Inventory)

#pragma mark  Eigenvalue
- (void)setItemsEigenvalue:(NSString *)value forPlayer:(NSNumber *)steamid
{
    if (!steamid) return;

    NSMutableDictionary *dict;
    NSDictionary *objc = [[NSUserDefaults standardUserDefaults] objectForKey:kEigenvalueSaveKey];
    if (objc && [objc isKindOfClass:[NSDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:objc];
    }else{
        dict = [NSMutableDictionary dictionary];
    }
    dict[steamid.stringValue] = value;
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kEigenvalueSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)itemsEigenvalueOfPlayer:(NSNumber *)steamid
{
    if (!steamid) return nil;
    
    NSDictionary *objc = [[NSUserDefaults standardUserDefaults] objectForKey:kEigenvalueSaveKey];
    if (objc && [objc isKindOfClass:[NSDictionary class]]) {
        return objc[steamid.stringValue] ;
    }
    return nil;
}


#pragma mark InventoryFolder
// 库存数据保存的文件夹
- (NSString *)folderPath
{
    NSString *folder = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@".com.wwwbbat.sp.inventory"];
    [self createFolderIfNeedArPath:folder];
    return folder;
}

// 用户库存数据保存的目录
- (NSString *)playerFolderPath:(NSNumber *)steam_id
{
    if (!steam_id) return nil;
    NSString *folder = [[self folderPath] stringByAppendingPathComponent:steam_id.description];
    return folder;
}

// 文件夹不存时 进行创建
- (void)createFolderIfNeedArPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

// 已归档的库存数据的更新日期。如果库存不存在，返回nil
- (NSDate *)archivedPlayerInventoryUpdateDate:(SPPlayer *)player
{
    NSString *folder = [self playerFolderPath:player.steam_id];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:folder error:nil];
    return [attributes fileModificationDate];
}

#pragma mark Inventory
// 读取已归档的库存数据。
- (void)readArchivedPlayerInventory:(SPPlayer *)player
{
    if (!player || !player.steam_id) return;
    
    NSString *inventoryPath = [[self playerFolderPath:player.steam_id] stringByAppendingPathComponent:kDefaultInventoryFileName];
    NSData *data = [NSData dataWithContentsOfFile:inventoryPath];
    player.inventory = [SPPlayerInventory yy_modelWithJSON:data];
}

- (BOOL)isArchivedPlayerInventoryExist:(SPPlayer *)player
{
    if (!player || !player.steam_id) return NO;
    
    NSString *path = [[self playerFolderPath:player.steam_id] stringByAppendingPathComponent:kDefaultInventoryFileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (void)saveArchivedPlayerInventory:(SPPlayer *)player
{
    if (!player || !player.steam_id || !player.inventory) return;
    
    NSString *playerFolder = [self playerFolderPath:player.steam_id];
    if (![[NSFileManager defaultManager] fileExistsAtPath:playerFolder]) {
        [self createFolderIfNeedArPath:playerFolder];
    }
    NSString *inventoryPath = [playerFolder stringByAppendingPathComponent:kDefaultInventoryFileName];
    [[NSFileManager defaultManager] removeItemAtPath:inventoryPath error:nil];
    
    
    NSData *data = [player.inventory yy_modelToJSONData];
    NSError *error;
    BOOL suc = [data writeToFile:inventoryPath options:NSDataWritingAtomic error:&error];
    NSAssert(suc && !error, @"保存失败！");
}

@end

static NSString *const kSPPlayerUpdateListSaveKey = @"kSPPlayerUpdateListSaveKey";

@implementation SPPlayerManager (Update)

- (NSArray<NSNumber *> *)updateListPlayers
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:kSPPlayerUpdateListSaveKey];
    if (object) {
        if (![object isKindOfClass:[NSArray class]]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSPPlayerUpdateListSaveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return nil;
        }else{
            return object;
        }
    }
    return nil;
}

- (void)setUpdateListPlayers:(NSArray<NSNumber *> *)players
{
    [[NSUserDefaults standardUserDefaults] setObject:players forKey:kSPPlayerUpdateListSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
