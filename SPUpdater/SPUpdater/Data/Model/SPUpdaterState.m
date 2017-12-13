//
//  SPUpdaterState.m
//  SPUpdater
//
//  Created by Jay on 2017/12/13.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "SPUpdaterState.h"
#import "SPLogHelper.h"
#import "SPPathManager.h"
#import <YYModel.h>

@implementation SPUpdaterState

+ (instancetype)lastState
{
    NSString *path = [SPPathManager statePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        SPUpdaterState *state = [SPUpdaterState yy_modelWithJSON:data];
        return state;
    
    }else{
        
        SPUpdaterState *state = [[SPUpdaterState alloc] init];
        return state;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oldServiceOn = NO;
        _adServiceOn = YES;
        _proServiceOn = YES;
        
        _lastCheckTime = [NSDate distantPast].timeIntervalSince1970;
        _nextCheckTime = [NSDate distantFuture].timeIntervalSince1970;
        _lastUpdateTime = _lastCheckTime;
        
        _baseDataVersion = 0;
        _langVersion = [NSMutableDictionary dictionary];
        _langPatchVersion = [NSMutableDictionary dictionary];
        
        _url = @"";
        _dota2Buildid = 0;
        _dota2LastUpdated = 0;
    }
    return self;
}

// 重置为上次存档的状态
- (void)reset
{
    SPLog(@"重置 Updater 状态");
    SPUpdaterState *state = [SPUpdaterState lastState];
    
    self.baseDataVersion = state.baseDataVersion;
    self.langVersion = [state.langVersion mutableCopy];
    self.langPatchVersion = [state.langPatchVersion mutableCopy];
    
    self.url = state.url;
    self.dota2Buildid = state.dota2Buildid;
    self.dota2LastUpdated = state.dota2LastUpdated;
}

// 保存状态
- (void)save
{
    id jsonObject = [self yy_modelToJSONObject];
    if (!jsonObject) return;
    SPLog(@"保存 Updater 状态：%@",jsonObject);
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:NULL];
    NSString *path = [SPPathManager statePath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [data writeToFile:path atomically:YES];
}

- (long long)getLangVersion:(NSString *)lang
{
    return [self.langVersion[lang] longLongValue];
}

- (void)setLangVersion:(long long)version lang:(NSString *)lang
{
    NSMutableDictionary *dict = [self.langVersion[lang] mutableCopy];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    dict[lang] = @(version);
    self.langVersion = dict;
}

- (long long)getPatchVersion:(NSString *)lang
{
    return [self.langPatchVersion[lang] longLongValue];
}

- (void)setPatchVersion:(long long)version lang:(NSString *)lang
{
    NSMutableDictionary *dict = [self.langPatchVersion[lang] mutableCopy];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    dict[lang] = @(version);
    self.langPatchVersion = dict;
}

@end
