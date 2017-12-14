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

@implementation SPInfoManager

+ (NSString *)latestItemGameURL
{
    SPLog(@"获取 items_game_url ");
    NSString *apiURL = @"https://api.steampowered.com/IEconItems_570/GetSchemaURL/v1?key=CD9010FD71FA1583192F9BDB87ED8164";
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL] options:NSDataReadingMappedIfSafe error:&error];
    if (!data || error) {
        SPLog(@"获取schemaURL失败！error:%@",error);
        return nil;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( !json || error || ![json isKindOfClass:[NSDictionary class]]) {
        SPLog(@"items_game数据错误。data:%@\nerror:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        return nil;
    }
    
    NSString *items_game_url = json[@"result"][@"items_game_url"];
    SPLog(@"items_game_url: %@",items_game_url);
    
    return items_game_url;
}

+ (BOOL)latestDotaInfo:(long long *)lastupdate
               buildid:(long long *)buildid
{
    NSData *data = [NSData dataWithContentsOfFile:[SPDota2PathManager dotaManifestPath]];
    if (!data) {
        SPLog(@"读取 appmanifest_570.acf 文件失败！");
        return NO;
    }

    VDFNode *root = [VDFParser parse:data];
    if (!root) {
        SPLog(@"解析 appmanifest_570.acf 文件失败！");
        return NO;
    }
    
    NSDictionary *dict = [root allDict];
    int state = [dict[@"AppState"][@"stateflags"] intValue];
    if (state != 4) {
        SPLog(@"StateFlags 不是 4 ? appmanifest_570.acf 内容：");
        SPLog(@"{\n%@\n}",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        SPLog(@"读取 appmanifest_570.acf 提前退出！");
        return NO;
    }
    NSString *lastupdateInfo = dict[@"AppState"][@"lastupdated"];
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
