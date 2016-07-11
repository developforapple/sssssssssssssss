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
        [shared.db open];
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
    NSString *dbFolder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@".com.wwwbbat.player.v1"];
    if (![fm fileExistsAtPath:dbFolder]) {
        [fm createDirectoryAtPath:dbFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbPath = [dbFolder stringByAppendingPathComponent:@"player.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    [db executeUpdate:@"CREATE TABLE player (steam_id integer PRIMARY KEY,\
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
    NSMutableArray *favorites = [NSMutableArray array];
    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM player WHERE star=1"];
    while ([result next]) {
        NSDictionary *dict = [result resultDictionary];
        SPPlayer *player = [SPPlayer yy_modelWithDictionary:dict];
        [favorites addObject:player];
    }
    [result close];
    return favorites;
}

- (BOOL)isStarred:(NSNumber *)steamid
{
    if (!steamid) return NO;
    
    BOOL isStarred = NO;
    FMResultSet *result = [self.db executeQuery:@"SELECT star FROM player WHERE steam_id=?",steamid];
    if ([result next]) {
        isStarred = [result boolForColumn:@"star"];
    }
    [result close];
    return isStarred;
}

- (void)setStarredUpdatedCallback:(void (^)(void))callback
{
    self.callback = callback;
}

- (void)unstarPlayer:(NSNumber *)steamid
{
    if (!steamid) return;
    
    [self.db executeUpdate:@"UPDATE player SET star=0 WHERE steam_id=?",steamid];
    [self callStarredUpdate];
}

// 增加星标。只操作已有记录的用户
- (void)starPlayer:(SPPlayer *)player
{
    if (!player) return;
    
    player.star = YES;
    
    NSDictionary *playerDict = [player yy_modelToJSONObject];
    
    NSString *sql = @"INSERT OR REPLACE INTO player VALUES(:steam_id,:avatar_url,:name,:star)";
    [self.db executeUpdate:sql withParameterDictionary:playerDict];
    [self callStarredUpdate];
}

- (void)callStarredUpdate
{
    if (self.callback) {
        self.callback();
    }
}

@end

#define kDefaultInventoryFileName @"inventory.dat"
#define kEigenvalueSaveKey @"SPEigenvalueList"

@implementation SPPlayerManager (Inventory)

#pragma mark  Eigenvalue
- (void)setItemsEigenvalue:(NSNumber *)value forPlayer:(NSNumber *)steamid
{
    if (!steamid) return;

    NSMutableDictionary *dict;
    NSDictionary *objc = [[NSUserDefaults standardUserDefaults] objectForKey:kEigenvalueSaveKey];
    if (objc && [objc isKindOfClass:[NSDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:objc];
    }else{
        dict = [NSMutableDictionary dictionary];
    }
    dict[steamid.description] = value.description;
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kEigenvalueSaveKey];
}

- (NSNumber *)itemsEigenvalueOfPlayer:(NSNumber *)steamid
{
    if (!steamid) return nil;
    
    NSDictionary *objc = [[NSUserDefaults standardUserDefaults] objectForKey:kEigenvalueSaveKey];
    if (objc && [objc isKindOfClass:[NSDictionary class]]) {
        return @([objc[steamid.description] longLongValue]);
    }
    return nil;
}


#pragma mark InventoryFolder
// 库存数据保存的文件夹
- (NSString *)folderPath
{
    NSString *folder = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@".com.wwwbbat.inventory.v1"];
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
    
    NSString *playerFolder = [self playerFolderPath:player.steam_id];
    if (![[NSFileManager defaultManager] fileExistsAtPath:playerFolder]) {
        return;
    }
    
    NSString *inventoryPath = [playerFolder stringByAppendingPathComponent:kDefaultInventoryFileName];
    NSException *e;
    player.inventory = [NSKeyedUnarchiver unarchiveObjectWithFile:inventoryPath exception:&e];
    
    NSAssert(player.inventory, @"");
}

// 对从服务器获取且模型化的库存数据进行归档
- (void)saveArchivedPlayerInventory:(SPPlayer *)player
{
    if (!player || !player.steam_id || !player.inventory) return;
    
    NSString *playerFolder = [self playerFolderPath:player.steam_id];
    if (![[NSFileManager defaultManager] fileExistsAtPath:playerFolder]) {
        [self createFolderIfNeedArPath:playerFolder];
    }
    NSString *inventoryPath = [playerFolder stringByAppendingPathComponent:kDefaultInventoryFileName];
    [[NSFileManager defaultManager] removeItemAtPath:inventoryPath error:nil];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:player.inventory];
    
    NSError *error;
    [data writeToFile:inventoryPath options:NSDataWritingAtomic error:&error];
    NSLog(@"保存库存归档成功");
}

@end

@implementation SPPlayerManager (Info)


@end