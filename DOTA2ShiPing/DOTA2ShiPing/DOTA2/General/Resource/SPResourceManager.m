//
//  SPResourceManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/12.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPResourceManager.h"
#import <AVOSCloud.h>

static NSString *const kDataVersionKey = @"kDotaDataBaseVersion";

@interface SPResourceManager ()
@property (assign, nonatomic) long long version;
@property (copy, nonatomic) NSString *folder;
@end

@implementation SPResourceManager

+ (BOOL)needInitializeDatabase
{
    return nil == [[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey];
}

- (void)initializeDatabase:(void (^)(float p))progressBlock
                completion:(void (^)(BOOL suc,NSError *error))completion
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:self.folder withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 请求
    AVFileQuery *query = [AVFileQuery query];
    [query whereKey:@"name" hasPrefix:@"dota_base_data"];
    [query findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects, NSError *error) {
        
        if (error) {
            completion?completion(NO,error):0;
        }else{
            AVFile *theLatestFile;
            NSInteger lastestVersion = 0;
            for (AVFile *aFile in objects) {
                if ([aFile isKindOfClass:[AVFile class]]) {
                    NSString *name = aFile.name;
                    NSString *version = [[[name stringByDeletingPathExtension] componentsSeparatedByString:@"_"] lastObject];
                    if (version) {
                        NSInteger versionNumber = [version longLongValue];
                        if (versionNumber > lastestVersion) {
                            theLatestFile = aFile;
                            lastestVersion = versionNumber;
                        }
                    }
                }
            }
            
            if (!theLatestFile) {
                completion?completion(NO,nil):0;
            }else{
                [theLatestFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (error) {
                        completion?completion(NO,error):0;
                    }else{
                        
                        NSString *name = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
                        NSString *tmpPath = [AppTmpPath stringByAppendingPathComponent:];
                        
                        
                    }
                } progressBlock:^(NSInteger percentDone) {
                    progressBlock?progressBlock(percentDone/100.f):0;
                }];
            }
        }
        
    }];
}

+ (instancetype)manager
{
    static SPResourceManager *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [SPResourceManager new];
        m.lang = @"schinese";
        m.version = [[[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey] longLongValue];
        m.folder = [AppDocumentsPath stringByAppendingPathComponent:@".base_data"];
        m.langPath = [m.folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",m.lang]];
        m.baseDataPath = [m.folder stringByAppendingPathComponent:@"data.json"];
        m.dbPath = [m.folder stringByAppendingPathComponent:@"item.db"];
    });
    return m;
}

- (void)checkDatabaseIntegrity
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *originDataPath = [[NSBundle mainBundle] pathForResource:@"dota_base_data_1499852091" ofType:@"zip"];
    NSAssert([fm fileExistsAtPath:originDataPath], @"需要修改原始数据包名");
    
    
    self.folder = [AppDocumentsPath stringByAppendingPathComponent:@".basedata"];
    if (![fm fileExistsAtPath:self.folder]) {
        [fm createDirectoryAtPath:self.folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.baseDataPath = [self.folder stringByAppendingPathComponent:@"data.json"];
    self.langPath = [self.folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",self.lang]];
    self.dbPath = [self.folder stringByAppendingPathComponent:@"item.db"];
    
    BOOL needOriginData = ![fm fileExistsAtPath:self.baseDataPath] || ![fm fileExistsAtPath:self.langPath] || ![fm fileExistsAtPath:self.dbPath];
    if (needOriginData) {
        NSString *oridinData = [[NSBundle mainBundle] pathForResource:@"dota_base_data_1499852091" ofType:@"zip"];
        
    }
}

- (void)checkUpdate
{
    
}

@end
