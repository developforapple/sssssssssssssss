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

// 更新信息
- (void)saveItemGameURL:(NSString *)url
             lastUpdate:(NSNumber *)lastUpdate
                buildid:(NSNumber *)buildid
        baseDataVersion:(NSNumber *)baseDataVersion;

- (void)saveLangVersion:(long long *)langVersion
                  patch:(long long *)patch
                   lang:(NSString *)lang;

// 获取最新的item_game_url
- (NSString *)latestItemGameURL;

// 获取最新的lastupdate和buildid
- (BOOL)latestDotaInfo:(long long *)lastupdate
               buildid:(long long *)buildid;

// 只有更新完成后才有用
@property (strong, nonatomic) NSString *tmpURL;
@property (strong, nonatomic) NSNumber *tmpLastUpdate;
@property (strong, nonatomic) NSNumber *tmpBuildid;

- (void)reset;

@end
