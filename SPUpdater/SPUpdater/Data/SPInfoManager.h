//
//  SPInfoManager.h
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPInfoManager : NSObject

// 当前信息
- (NSString *)itemGameURL;
- (long long)lastUpdate;
- (long long)buildid;
- (long long)baseDataVersion;
- (long long)langFileVersion:(NSString *)lang;
- (long long)langPatchFileVersion:(NSString *)lang;

// 获取最新的item_game_url
- (NSString *)latestItemGameURL;

// 获取最新的lastupdate和buildid。 当配置文件的state不为4时，返回NO。
- (BOOL)latestDotaInfo:(long long *)lastupdate
               buildid:(long long *)buildid;

- (void)reset;

@end
