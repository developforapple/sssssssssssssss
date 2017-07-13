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
#import <AVOSCloud.h>
#import <SSZipArchive.h>

static NSString *const kDataVersionKey = @"kDotaDataBaseVersion";
static NSString *const zipPassword = @"wwwbbat.DOTA2.19880920";

@interface SPResourceManager ()
@property (assign, nonatomic) long long version;
@property (assign, nonatomic) long long nextVersion;
@property (copy, nonatomic) NSString *folder;
@end

@implementation SPResourceManager

+ (BOOL)needInitializeDatabase
{
    return nil == [[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lang = kLangSchinese;
        self.version = [[[NSUserDefaults standardUserDefaults] objectForKey:kDataVersionKey] longLongValue];
    }
    return self;
}

- (void)checkBaseDataUpdate:(void (^)(AVFile *, NSError *))completion
{
    if (!completion) return;
    
    // 先检查数据版本
    AVFileQuery *versionQuery = [AVFileQuery query];
    [versionQuery whereKey:@"name" equalTo:@"base_data_version"];
    [versionQuery findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects, NSError *error) {
        if (error) {
            completion(nil,error);
            return;
        }
        AVFile *versionFile = [objects firstObject];
        long long version = versionFile?[versionFile.metaData[@"version"] longLongValue]: (self.version+1);
        if (version > self.version) {
            //需要更新, 获取最新文件
            
            AVFileQuery *query = [AVFileQuery query];
            [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"base_data_%lld",version]];
            [query findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects, NSError *error) {
                if (error) {
                    completion(nil,error);
                    return;
                }
                AVFile *file = [objects firstObject];
                completion(file,nil);
            }];
        }else{
            completion(nil,nil);
        }
    }];
}

- (void)checkLangMainFile:(void (^)(AVFile *,NSError *))completion
{
    if (!completion) return;
    
    AVFileQuery *query = [AVFileQuery query];
    [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"%@.zip",self.lang]];
    [query findFilesInBackgroundWithBlock:^(NSArray<AVFile *> *objects, NSError *error) {
        if (error) {
            completion(nil,error);
            return;
        }
        AVFile *file = [objects firstObject];
        completion(file,nil);
    }];
}

- (void)checkUpdate
{
    BOOL baseDataVaild = [SPBaseData isBaseDataValid];
    BOOL langDataVaild = [SPBaseData isLangDataValid:self.lang];
    
    ygweakify(self);
    
    // 基础数据
    [self checkBaseDataUpdate:^(AVFile *file, NSError *error) {
        
        ygstrongify(self);
        
        if (error) {
            self.error = error;
            return;
        }
        
        if (!file) {
            self.needUpdate = @0;
            return;
        }
        
        self.baseDataFile = file;
        
        //基础数据需要更新，检查本地数据更新
        BOOL langDataVaild = [SPBaseData isLangDataValid:self.lang];
        if (!langDataVaild) {
            //语言主文件失效，需要下载
            ygweakify(self);
            [self checkLangMainFile:^(AVFile *langMainFile, NSError *error2) {
                ygstrongify(self);
                if (error2) {
                    self.error = error2;
                    return ;
                }
                self.langFile = langMainFile;
                
            }];
        }
    }];
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
                        RunOnGlobalQueue(^{
                            NSString *name = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
                            NSString *zipTmpPath = [AppTmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",name]];
                            NSString *unzipTmpPath = [AppTmpPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
                            
                            [[NSFileManager defaultManager] removeItemAtPath:zipTmpPath error:nil];
                            [[NSFileManager defaultManager] removeItemAtPath:unzipTmpPath error:nil];
                            [[NSFileManager defaultManager] createDirectoryAtPath:unzipTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
                            
                            [data writeToFile:zipTmpPath atomically:YES];
    
                            [SSZipArchive unzipFileAtPath:zipTmpPath toDestination:unzipTmpPath overwrite:NO password:zipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                                
                            } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                                if (error) {
                                    NSLog(@"解压缩失败！%@",error);
                                    completion?completion(NO,error):nil;
                                }else{
                                    NSString *dbPath = [unzipTmpPath stringByAppendingPathComponent:@"item.db"];
                                    NSString *baseDataPath = [unzipTmpPath stringByAppendingPathComponent:@"data.json"];
                                    NSString *langPath = [unzipTmpPath stringByAppendingPathComponent:@"sc"];
                                    
                                }
                            }];
                        });
                    }
                } progressBlock:^(NSInteger percentDone) {
                    progressBlock?progressBlock(percentDone/100.f):0;
                }];
            }
        }
        
    }];
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

@end
