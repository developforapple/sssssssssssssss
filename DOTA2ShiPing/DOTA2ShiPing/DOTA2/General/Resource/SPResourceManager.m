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

@property (strong, nonatomic) AVQuery *baseDataVersionQuery;
@property (strong, nonatomic) AVQuery *langDataVersionQuery;
@property (strong, nonatomic) AVQuery *langPatchVersionQuery;

@property (strong, nonatomic) AVQuery *baseDataQuery;
@property (strong, nonatomic) AVQuery *langDataQuery;
@property (strong, nonatomic) AVQuery *langPatchQuery;

@end

@implementation SPResourceManager

+ (instancetype)manager
{
    static SPResourceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPResourceManager alloc] init];
    });
    return manager;
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
    SPLog(@"---------检查基础数据更新---------");
    if (!completion) return;
    
    ygweakify(self);
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:@"base_data_version"];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        ygstrongify(self);
        if (error) {
            SPLog(@"获取版本号出错：%@",error);
            completion(nil,error,0);
            return;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.version;
        SPLog(@"新版本号：%lld, 当前版本号:%lld",version,self.version);
        
        if (version > self.version) {
            NSString *name2 = [NSString stringWithFormat:@"base_data_%lld.zip",version];
            SPLog(@"需要更新 :%@",name2);
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:name2];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    SPLog(@"获取基础数据 出错：%@",error2);
                    completion(nil,error2,version);
                    return;
                }
                SPLog(@"获取基础数据 完成");
                completion(objects2.firstObject,nil,version);
            }];
            self.baseDataQuery = query2;
        }else{
            SPLog(@"不需要更新");
            completion(nil,nil,version);
        }
    }];
    self.baseDataVersionQuery = query;
}

- (void)checkLangMainFileUpdate:(void (^)(AVFile *,NSError *, long long version))completion
{
    SPLog(@"---------检查主语言文件更新---------");
    if (!completion) return;
    
    ygweakify(self);
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_version_%@",self.lang]];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        ygstrongify(self);
        if (error) {
            SPLog(@"获取版本号出错：%@",error);
            completion(nil,error, 0);
            return ;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.langVersion;
        SPLog(@"新版本号：%lld, 当前版本号:%lld",version,self.version);
        
        if (version > self.langVersion) {
            //需要更新语言主文件
            NSString *name2 = [NSString stringWithFormat:@"%@_%lld.zip",self.lang,version];
            SPLog(@"需要更新 :%@",name2);
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:name2];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    SPLog(@"获取主语言文件 出错：%@",error2);
                    completion(nil,error2,version);
                    return ;
                }
                SPLog(@"获取主语言文件 完成");
                completion(objects2.firstObject,nil,version);
            }];
            self.langDataQuery = query2;
        }else{
            SPLog(@"不需要更新");
            completion(nil,nil,version);
        }
    }];
    self.langDataVersionQuery = query;
}

- (void)checkLangPatchFile:(long long)version completion:(void (^)(AVFile *,NSError *, long long version))completion
{
    SPLog(@"---------检查语言补丁文件更新---------");
    if (!completion) return;
    
    ygweakify(self);
    AVQuery *query = [AVQuery queryWithClassName:@"Version"];
    [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_patch_version_%@",self.lang]];
    [query findObjectsInBackgroundWithBlock:^(NSArray<AVObject *> *objects, NSError *error) {
        ygstrongify(self);
        if (error) {
            SPLog(@"获取版本号出错：%@",error);
            completion(nil,error, 0);
            return ;
        }
        AVObject *obj = objects.firstObject;
        long long version = obj ? [[obj objectForKey:@"version"] longLongValue] : self.langPatchVersion;
        SPLog(@"新版本号：%lld, 当前版本号:%lld",version,self.version);
        
        if (version > self.langPatchVersion) {
            NSString *name2 = [NSString stringWithFormat:@"%@_%lld_%lld_patch.zip",self.lang,self.latestLangVersion,version];
            SPLog(@"需要更新 :%@",name2);
            AVFileQuery *query2 = [AVFileQuery query];
            [query2 whereKey:@"name" equalTo:name2];
            [query2 findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects2, NSError *error2) {
                if (error2) {
                    SPLog(@"获取语言补丁 出错：%@",error2);
                    completion(nil,error2,version);
                    return ;
                }
                SPLog(@"获取语言补丁 完成");
                completion(objects2.firstObject,nil,version);
            }];
            self.langPatchQuery = query2;
        }else{
            SPLog(@"不需要更新");
            completion(nil,nil,version);
        }
    }];
    self.langPatchVersionQuery = query;
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
        
        SPLog(@"基础数据：%@",file);
        
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
            
            SPLog(@"语言数据：%@",file2);
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
                
                SPLog(@"语言补丁：%@",file3);
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
        SPLog(@"需要更新");
        self.needUpdate = @YES;
    }else{
        SPLog(@"不要更新");
        self.needUpdate = @NO;
    }
}

#pragma mark - Update
- (void)beginUpdate
{
    SPLog(@"---------开始下载----------");
    
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
                SPLog(@"--------结束下载---------");
                [self downloadDidCompleted];
            }];
        }];
    }];
}

- (void)getBaseData:(void (^)(BOOL suc))completion
{
    if (self.baseDataFile) {
        SPLog(@"开始下载基础数据：%@",self.baseDataFile);
        ygweakify(self);
        [self.baseDataFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            NSString  *filePath = [self.baseDataFile localPath];
            BOOL suc = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (suc) {
                SPLog(@"下载完成，路径：%@",filePath);
            }else{
                SPLog(@"下载出错，文件不存在：%@",filePath);
            }
            completion?completion(error==nil && suc):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            SPLog(@"基础数据：%d%%",(int)percentDone);
            self.baseDataProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        SPLog(@"跳过基础数据");
        self.baseDataProgress = 1.f;
        [self updateProgress];
        completion?completion(YES):0;
    }
}

- (void)getLangMainData:(void (^)(BOOL suc))completion
{
    if (self.langFile) {
        SPLog(@"开始下载主语言文件：%@",self.langFile);
        ygweakify(self);
        [self.langFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            NSString  *filePath = [self.langFile localPath];
            BOOL suc = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (suc) {
                SPLog(@"下载完成，路径：%@",filePath);
            }else{
                SPLog(@"下载出错，文件不存在：%@",filePath);
            }
            completion?completion(error==nil && suc):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            SPLog(@"主语言文件：%d%%",(int)percentDone);
            self.langFileProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        SPLog(@"跳过主语言文件");
        self.langFileProgress = 1.f;
        [self updateProgress];
        completion?completion(YES):0;
    }
}

- (void)getLangPatchData:(void (^)(BOOL suc))completion
{
    if (self.langPatchFile) {
        SPLog(@"开始下载语言补丁：%@",self.langFile);
        ygweakify(self);
        [self.langPatchFile getDataStreamInBackgroundWithBlock:^(NSInputStream *stream, NSError *error) {
            ygstrongify(self);
            self.error = error;
            NSString  *filePath = [self.langPatchFile localPath];
            BOOL suc = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (suc) {
                SPLog(@"下载完成，路径：%@",filePath);
            }else{
                SPLog(@"下载出错，文件不存在：%@",filePath);
            }
            completion?completion(error==nil && suc):0;
        } progressBlock:^(NSInteger percentDone) {
            ygstrongify(self);
            SPLog(@"语言补丁：%d%%",(int)percentDone);
            self.langPatchProgress = percentDone/100.f;
            [self updateProgress];
        }];
    }else{
        SPLog(@"跳过语言补丁");
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
    SPLog(@"-------开始解压缩--------");
    // 延迟0.1秒为了防止生成的随机目录发生重复
    ygweakify(self);
    [self unzipBaseData:^(BOOL suc) {
        if (!suc) return;
        RunAfter(.1, ^{
            ygstrongify(self);
            [self unzipLangMainData:^(BOOL suc) {
                if (!suc) return ;
                RunAfter(.1, ^{
                    ygstrongify(self);
                    [self unzipLangPatchData:^(BOOL suc) {
                        if (!suc) return ;
                        ygstrongify(self);
                        SPLog(@"--------解压缩完成---------");
                        RunAfter(.1, ^{
                            [self unzipDidCompleted];
                        });
                    }];
                });
            }];
        });
    }];
}

- (void)unzipBaseData:(void (^)(BOOL suc))completion
{
    if (self.baseDataFile) {
        SPLog(@"解压缩基础数据");
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.baseDataFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.baseDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"data.json"];
            self.dbDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"item.db"];
            if (error) {
                SPLog(@"解压缩基础数据出错：%@",error);
            }else{
                SPLog(@"解压缩基础数据完成");
            }
            completion?completion(succeeded):0;
        }];
    }else{
        SPLog(@"跳过基础数据");
        completion(YES);
    }
}

- (void)unzipLangMainData:(void (^)(BOOL suc))completion
{
    if (self.langFile) {
        SPLog(@"解压缩主语言文件");
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.langFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.langDataTmpPath = [tmpFolder stringByAppendingPathComponent:@"lang.json"];
            if (error) {
                SPLog(@"解压缩主语言文件出错：%@",error);
            }else{
                SPLog(@"解压缩主语言文件完成");
            }
            completion?completion(succeeded):0;
        }];
    }else{
        SPLog(@"跳过主语言文件");
        completion(YES);
    }
}

- (void)unzipLangPatchData:(void (^)(BOOL suc))completion
{
    if (self.langPatchFile) {
        SPLog(@"解压缩语言补丁");
        NSString *tmpFolder = [SPBaseData randomTmpFolder];
        NSString *zipPath = self.langPatchFile.localPath;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:tmpFolder overwrite:YES password:zipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            self.error = error;
            self.langPatchTmpPath = [tmpFolder stringByAppendingPathComponent:@"lang_patch.json"];
            if (error) {
                SPLog(@"解压缩语言补丁出错：%@",error);
            }else{
                SPLog(@"解压缩语言补丁完成");
            }
            completion?completion(YES):0;
        }];
    }else{
        SPLog(@"跳过语言补丁");
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
    SPLog(@"-------开始保存数据-------");
    [self saveBaseData];
    [self saveLangMainData];
    [self saveLangPatchData];
    
    SPLog(@"-------保存数据完成-------");
    [self updateDidCompleted];
}

- (BOOL)saveBaseData
{
    if (self.baseDataFile) {
        SPLog(@"保存基础数据");
        [SPBaseData saveDataJSONfrom:self.baseDataTmpPath];
        [SPBaseData saveDBFrom:self.dbDataTmpPath];
    }else{
        SPLog(@"跳过基础数据");
    }
    return YES;
}

- (BOOL)saveLangMainData
{
    if (self.langFile) {
        SPLog(@"保存主语言文件");
        [SPBaseData saveLangDataFrom:self.langDataTmpPath lang:self.lang];
    }else{
        SPLog(@"跳过主语言文件");
    }
    return YES;
}

- (BOOL)saveLangPatchData
{
    if (self.langPatchFile) {
        SPLog(@"保存语言补丁");
        [SPBaseData saveLangPatchDataFrom:self.langPatchTmpPath lang:self.lang];
    }else{
        SPLog(@"跳过语言补丁");
    }
    return YES;
}

- (void)clean
{
    self.needUpdate = nil;
    self.progress = 0;
    self.downloadCompleted = nil;
    self.unzipCompleted = nil;
    self.completion = nil;
    self.baseDataFile = nil;
    self.langFile = nil;
    self.langPatchFile = nil;
    self.error = nil;
    self.baseDataQuery = nil;
    self.langDataQuery = nil;
    self.langPatchQuery = nil;
    self.baseDataVersionQuery = nil;
    self.langPatchVersionQuery = nil;
    self.langDataVersionQuery = nil;
    [FileManager removeItemAtPath:[SPBaseData tmpFolder] error:nil];
}

#pragma mark - 

- (void)updateDidCompleted
{
    SPLog(@"更新版本号");
    
    SPLog(@"基础数据版本：%lld",self.latestVersion);
    self.version = self.latestVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.version) forKey:kDataVersionKey];
    
    SPLog(@"主语言文件版本：%lld",self.latestLangVersion);
    self.langVersion = self.latestLangVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.langVersion) forKey:[self langVersionKey:self.lang]];
    
    SPLog(@"语言补丁版本：%lld",self.latestLangPatchVersion);
    self.langPatchVersion = self.latestLangPatchVersion;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.langPatchVersion) forKey:[self langPatchVersionKey:self.lang]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.completion) {
        self.completion();
    }
    
    SPLog(@"-----清理-------");
    [self clean];
}

- (void)serializeData
{
    
}

@end
