//
//  SPResourceManager.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/12.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPResourceManager.h"
#import "SPBaseData.h"
#import "SPLocale.h"
#import "AVOSCloud.h"
#import "SSZipArchive.h"

static NSString *const kDataVersionKey = @"kDotaDataBaseVersion";
static NSString *const zipPassword = @"wwwbbat.DOTA2.19880920";

@interface SPResourceManager ()
@property (assign, nonatomic) long long version;
@property (assign, nonatomic) long long latestVersion;
@property (assign, nonatomic) long long langVersion;
@property (assign, nonatomic) long long latestLangVersion;
@property (assign, nonatomic) long long langPatchVersion;
@property (assign, nonatomic) long long latestLangPatchVersion;

@property (assign, nonatomic) float baseDataProgress;
@property (assign, nonatomic) float langFileProgress;
@property (assign, nonatomic) float langPatchProgress;

@property (copy, nonatomic) NSString *baseDataTmpPath;
@property (copy, nonatomic) NSString *dbDataTmpPath;
@property (copy, nonatomic) NSString *langDataTmpPath;
@property (copy, nonatomic) NSString *langPatchTmpPath;

@end

@implementation SPResourceManager

+ (BOOL)needInitializeDatabase
{
    return nil == [[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey];
}

- (NSString *)lang
{
    return GetLang;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.version = [[[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey] longLongValue];
        self.langVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:[self langVersionKey:self.lang]] longLongValue];
        self.langPatchVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:[self langPatchVersionKey:self.lang]] longLongValue];
    }
    return self;
}

- (NSString *)langVersionKey:(NSString *)lang
{
    return [NSString stringWithFormat:@"kLangDataVersion_%@",lang];
}

- (NSString *)langPatchVersionKey:(NSString *)lang
{
    return [NSString stringWithFormat:@"kLangPatchVersion_%@",lang];
}

#pragma mark - Check
- (void)checkBaseDataUpdate:(void (^)(AVFile *, NSError *, long long version))completion
{
    if (!completion) return;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:@"base_data_version"];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        if (error) {
            completion(nil,error,0);
            return;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.version;
        
        NSLog(@"新版本：%lld, 当前版本:%lld",version,self.version);
        
        if (version > self.version) {
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:[NSString stringWithFormat:@"base_data_%lld.zip",version]];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    completion(nil,error2,version);
                    return;
                }
                completion(objects2.firstObject,nil,version);
            }];
        }else{
            completion(nil,nil,version);
        }
    }];
}

- (void)checkLangMainFileUpdate:(void (^)(AVFile *,NSError *, long long version))completion
{
    if (!completion) return;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_version_%@",self.lang]];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        if (error) {
            completion(nil,error, 0);
            return ;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.langVersion;
        if (version > self.langVersion) {
            //需要更新语言主文件
            
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@_%lld.zip",self.lang,version]];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    completion(nil,error2,version);
                    return ;
                }
                completion(objects2.firstObject,nil,version);
            }];
            
        }else{
            completion(nil,nil,version);
        }
    }];
}

- (void)checkLangPatchFile:(long long)version completion:(void (^)(AVFile *,NSError *, long long version))completion
{
    if (!completion) return;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_patch_version_%@",self.lang]];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        if (error) {
            completion(nil,error, 0);
            return ;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.langPatchVersion;
        if (version > self.langPatchVersion) {
            
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@_%lld_%lld_patch.zip",self.lang,self.latestLangVersion,version]];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    completion(nil,error2,version);
                    return ;
                }
                completion(objects2.firstObject,nil,version);
            }];
            
        }else{
            completion(nil,nil,version);
        }
    }];
}

- (void)checkUpdate
{
    ygweakify(self);
    
    // 基础数据
    [self checkBaseDataUpdate:^(AVFile *file, NSError *error, long long version) {
        
        ygstrongify(self);
        
        if (error) {
            self.error = error;
            return;
        }
        
        self.baseDataFile = file;
        self.latestVersion = version;
        
        // 语言数据
        ygweakify(self);
        [self checkLangMainFileUpdate:^(AVFile *file2, NSError *error2, long long version2) {
            ygstrongify(self);
            
            if (error2) {
                self.error = error2;
                return;
            }
            
            self.langFile = file2;
            self.latestLangVersion = version2;
            
            
            // 语言补丁
            ygweakify(self);
            [self checkLangPatchFile:version2 completion:^(AVFile *file3, NSError *error3, long long version3) {
                ygstrongify(self);
                if (error3) {
                    self.error = error3;
                    return ;
                }
                self.langPatchFile = file3;
                self.latestLangPatchVersion = version3;
                
                [self decideNeedUpdate];
            }];
        }];
    }];
}

- (void)decideNeedUpdate
{
    if (!self.error && (self.baseDataFile || self.langFile || self.langPatchFile) ) {
        self.needUpdate = @YES;
    }else{
        self.needUpdate = @NO;
    }
}

#pragma mark - Update
- (void)beginUpdate
{
    self.baseDataProgress = 0.f;
    self.langFileProgress = 0.f;
    self.langPatchProgress = 0.f;
    
    ygweakify(self);
    [self getBaseData:^(BOOL suc) {
        if (!suc) return;
        ygstrongify(self);
        [self getLangMainData:^(BOOL suc) {
            if(!suc) return ;
            ygstrongify(self);
            [self getLangPatchData:^(BOOL suc) {
                if (!suc) return ;
                ygstrongify(self);
                [self downloadDidCompleted];
            }];
        }];
    }];
}

- (void)getBaseData:(void (^)(BOOL suc))completion
{
    if (self.baseDataFile) {
        ygweakify(self);
        [self.baseDataFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            completion?completion(error==nil):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            self.baseDataProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        self.baseDataProgress = 1.f;
        [self updateProgress];
        completion?completion(YES):0;
    }
}

- (void)getLangMainData:(void (^)(BOOL suc))completion
{
    if (self.langFile) {
        ygweakify(self);
        [self.langFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            completion?completion(error==nil):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            self.langFileProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        self.langFileProgress = 1.f;
        [self updateProgress];
        completion?completion(YES):0;
    }
}

- (void)getLangPatchData:(void (^)(BOOL suc))completion
{
    if (self.langPatchFile) {
        ygweakify(self);
        [self.langPatchFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            completion?completion(error==nil):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            self.langPatchProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        self.langPatchProgress = 1.f;
        [self updateProgress];
        completion?completion(YES):0;
    }
}

- (void)updateProgress
{
    self.progress = self.baseDataProgress * 0.6f + self.langFileProgress * 0.2f + self.langPatchProgress * 0.2f;
}

- (void)downloadDidCompleted
{
    if (self.downloadCompleted) {
        self.downloadCompleted();
    }
}

#pragma mark - Unzip
- (void)beginUnzip
{
    ygweakify(self);
    [self unzipBaseData:^(BOOL suc) {
        if (!suc) return;
        ygstrongify(self);
        [self unzipLangMainData:^(BOOL suc) {
            if (!suc) return ;
            ygstrongify(self);
            [self unzipLangPatchData:^(BOOL suc) {
                if (!suc) return ;
                ygstrongify(self);
                [self unzipDidCompleted];
            }];
        }];
    }];
}

- (void)unzipBaseData:(void (^)(BOOL suc))completion
{
    if (self.baseDataFile) {
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.baseDataFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.baseDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"data.json"];
            self.dbDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"item.db"];
            completion?completion(succeeded):0;
        }];
    }else{
        completion(YES);
    }
}

- (void)unzipLangMainData:(void (^)(BOOL suc))completion
{
    if (self.langFile) {
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.langFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.langDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"lang.json"];
            completion?completion(succeeded):0;
        }];
    }else{
        completion(YES);
    }
}

- (void)unzipLangPatchData:(void (^)(BOOL suc))completion
{
    if (self.langPatchFile) {
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.langPatchFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.langPatchTmpPath = [tmpFolder stringByAppendingPathComponent:@"lang_patch.json"];
            completion?completion(YES):0;
        }];
    }else{
        completion(YES);
    }
}

- (void)unzipDidCompleted
{
    if (self.unzipCompleted) {
        self.unzipCompleted();
    }
}

#pragma mark - Save
- (void)saveData
{
    [self saveBaseData];
    [self saveLangMainData];
    [self saveLangPatchData];
    
    [self updateDidCompleted];
}

- (BOOL)saveBaseData
{
    if (self.baseDataFile) {
        [SPBaseData saveDataJSONfrom:self.baseDataTmpPath];
        [SPBaseData saveDBFrom:self.dbDataTmpPath];
    }
    return YES;
}

- (BOOL)saveLangMainData
{
    if (self.langFile) {
        [SPBaseData saveLangDataFrom:self.langDataTmpPath lang:self.lang];
    }
    return YES;
}

- (BOOL)saveLangPatchData
{
    if (self.langPatchFile) {
        [SPBaseData saveLangPatchDataFrom:self.langPatchTmpPath lang:self.lang];
    }
    return YES;
}

- (void)cleanTmp
{
    [FileManager removeItemAtPath:[SPBaseData tmpFolder] error:nil];
}

#pragma mark - 

- (void)updateDidCompleted
{
    self.version = self.latestVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.version) forKey:kDataVersionKey];
    self.langVersion = self.latestLangVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.langVersion) forKey:[self langVersionKey:self.lang]];
    self.langPatchVersion = self.latestLangPatchVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.langPatchVersion) forKey:[self langPatchVersionKey:self.lang]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.completion) {
        self.completion();
    }
    
    [self cleanTmp];
}

- (void)serializeData
{
    
}

@end
