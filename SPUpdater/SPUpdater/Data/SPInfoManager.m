//
//  SPInfoManager.m
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "SPInfoManager.h"
#import "SPPathManager.h"
#import "VDFParser.h"
#import "SPLogHelper.h"

static NSString *kInfoKeyItemGameURL = @"item_game_url";
static NSString *kInfoKeyLastUpdate = @"lastupdate";
static NSString *kInfoKeyBuildID = @"buildid";
static NSString *kInfoKeyBaseData = @"basedata";
static NSString *kInfoKeyLang = @"lang";
static NSString *kInfoKeyLangPatch = @"langpatch";

@interface SPInfoManager ()
@property (strong, nonatomic) NSMutableDictionary *info;
@end

@implementation SPInfoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self readInfo];
    }
    return self;
}

- (NSString *)itemGameURL
{
    return self.info[kInfoKeyItemGameURL];
}

- (long long)lastUpdate
{
    return [self.info[kInfoKeyLastUpdate] longLongValue];
}

- (long long)buildid
{
    return [self.info[kInfoKeyBuildID] longLongValue];
}

- (long long)baseDataVersion
{
    return [self.info[kInfoKeyBaseData] longLongValue];
}

- (long long)langFileVersion:(NSString *)lang
{
    return [self.info[kInfoKeyLang][lang] longLongValue];
}

- (long long)langPatchFileVersion:(NSString *)lang
{
    return [self.info[kInfoKeyLangPatch][lang] longLongValue];
}

- (NSString *)infoPath
{
    return [[SPPathManager rootPath] stringByAppendingPathComponent:@"info.json"];
}

- (void)reset
{
    self.tmpURL = nil;
    self.tmpBuildid = nil;
    self.tmpLastUpdate = nil;
    [self readInfo];
}

- (NSMutableDictionary *)defaultInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[kInfoKeyItemGameURL] = @"0";
    info[kInfoKeyLastUpdate] = @"0";
    info[kInfoKeyBuildID] = @"0";
    info[kInfoKeyBaseData] = @"0";
    info[kInfoKeyLang] = [NSMutableDictionary dictionary];
    info[kInfoKeyLangPatch] = [NSMutableDictionary dictionary];
    return info;
}

- (void)readInfo
{
    NSData *data = [NSData dataWithContentsOfFile:[self infoPath]];
    if (!data) {
        SPLog(@"info.json不存在，创建新的");
        self.info = [self defaultInfo];
        [self saveInfo];
    }else{
        NSError *error;
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error && dict && [dict isKindOfClass:[NSDictionary class]]) {
            self.info = dict;
        }else{
            SPLog(@"读取 info.json 出错！重新创建");
            self.info = [self defaultInfo];
            [self saveInfo];
        }
    }
}

- (void)saveInfo
{
    if (!self.info) {
        SPLog(@"info 为空？");
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.info options:NSJSONWritingPrettyPrinted error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self infoPath] error:nil];
    [data writeToFile:[self infoPath] atomically:YES];
    SPLog(@"更新info成功");
}

- (void)saveItemGameURL:(NSString *)url
             lastUpdate:(NSNumber *)lastUpdate
                buildid:(NSNumber *)buildid
        baseDataVersion:(NSNumber *)baseDataVersion
{
    @synchronized (self){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (url) {
            dict[kInfoKeyItemGameURL] = url;
        }
        if (lastUpdate) {
            dict[kInfoKeyLastUpdate] = [lastUpdate stringValue];
        }
        if (buildid) {
            dict[kInfoKeyBuildID] = [buildid stringValue];
        }
        if (baseDataVersion) {
            dict[kInfoKeyBaseData] = [baseDataVersion stringValue];
        }
        SPLog(@"准备更新info：%@",dict);
        [self.info addEntriesFromDictionary:dict];
        [self saveInfo];
    }
}

- (void)saveLangVersion:(long long *)langVersion
                  patch:(long long *)patch
                   lang:(NSString *)lang
{
    @synchronized (self){
        NSMutableDictionary *langDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *langPatchDict = [NSMutableDictionary dictionary];
        
        if (langVersion) {
            langDict[lang] = [@(*langVersion) stringValue];
        }
        if (patch) {
            langPatchDict[lang] = [@(*patch) stringValue];
        }
        
        NSMutableDictionary *selfLangDict = self.info[kInfoKeyLang];
        [selfLangDict addEntriesFromDictionary:langDict];
        
        NSMutableDictionary *selfLangPatchDict = self.info[kInfoKeyLangPatch];
        [selfLangPatchDict addEntriesFromDictionary:langPatchDict];
        
        SPLog(@"准备更新info：%@,%@",langDict,langPatchDict);
        [self saveInfo];
    }
}

- (NSString *)latestItemGameURL
{
    SPLog(@"获取 items_game_url ");
    NSString *apiURL = @"https://api.steampowered.com/IEconItems_570/GetSchemaURL/v1?key=CD9010FD71FA1583192F9BDB87ED8164";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL]];
    if (!data) {
        SPLog(@"获取schemaURL失败！");
        return nil;
    }
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (!(json && !error && [json isKindOfClass:[NSDictionary class]])) {
        SPLog(@"items_game数据错误");
        return nil;
    }
    
    NSString *items_game_url = json[@"result"][@"items_game_url"];
    SPLog(@"items_game_url: %@",items_game_url);
    
    return items_game_url;
}

- (BOOL)latestDotaInfo:(long long *)lastupdate
               buildid:(long long *)buildid
{
    NSData *data = [NSData dataWithContentsOfFile:[SPPathManager dotaManifestPath]];
    if (!data) {
        SPLog(@"Manifest文件读取失败！");
        return NO;
    }

    VDFNode *root = [VDFParser parse:data];
    if (!root) {
        SPLog(@"解析Manifest文件失败！");
        return NO;
    }
    
    NSDictionary *dict = [root allDict];
    NSString *lastupdateInfo = dict[@"AppState"][@"LastUpdated"];
    NSString *buildidInfo = dict[@"AppState"][@"buildid"];
    
    if (lastupdate) {
        *lastupdate = lastupdateInfo.longLongValue;
    }
    if (buildid) {
        *buildid = buildidInfo.longLongValue;
    }
    return YES;
}

@end
