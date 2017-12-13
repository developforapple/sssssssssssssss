//
//  SPUpdater.m
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "SPUpdater.h"
#import "SPLocalMapping.h"
#import "SPPathManager.h"
#import "VDFParser.h"
#import <AFNetworking.h>
#import <AVOSCloud.h>
#import "SPItemGameData.h"
#import "SPLogHelper.h"

typedef NS_ENUM(NSInteger, ServiceType) {
    ServiceTypeOld,
    ServiceTypePro,
    ServiceTypeAd,
};

static ServiceType kNoneType = -1;
static ServiceType kDoneType = 999;

NSString *logStringForServiceType(ServiceType type){
    switch (type) {
        case ServiceTypeOld:    return @"饰品总汇";
        case ServiceTypeAd:     return @"刀塔饰品 ad";
        case ServiceTypePro:    return @"刀塔饰品 pro";
    }
    return nil;
}

NSString *appidForServiceType(ServiceType type){
    switch (type) {
        case ServiceTypeOld:    return @"uy7j0G50gYzI8jOopjxUNPpT-gzGzoHsz";
        case ServiceTypeAd:     return @"K1mtJOrizsvrywTyYq85j3xL-gzGzoHsz";
        case ServiceTypePro:    return @"nyAIoo7OddnRAE0Ch7WOTjRx-gzGzoHsz";
    }
    return nil;
}

NSString *keyForServiceType(ServiceType type){
    switch (type) {
        case ServiceTypeOld:    return @"RkF7f6l3KjnnOKA7jTD1YFn7";
        case ServiceTypeAd:     return @"6VNgktNuzuT7exKg1fTF8x4q";
        case ServiceTypePro:    return @"IVLqzHqTqdjbXch8YekoUEdf";
    }
    return nil;
}

NSString *maskterKeyForServiceType(ServiceType type){
    switch (type) {
        case ServiceTypeOld:    return @"";
        case ServiceTypeAd:     return @"WcTv3IdnLVlToQw0eO6NVlFz";
        case ServiceTypePro:    return @"bRJEHiGAEKLVpxXcwb8X9O22";
    }
    return nil;
}

@interface SPUpdater ()
@property (strong, readwrite, nonatomic) SPInfoManager *info;

@property (assign, readwrite, getter=isUpdating, nonatomic) BOOL updating;

@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) dispatch_block_t timerBlock;

@property (strong, nonatomic) AFURLSessionManager *manager;
@property (weak, nonatomic) NSTextView *textView;

@end

@implementation SPUpdater

+ (instancetype)updater
{
    static SPUpdater *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPUpdater new];
        instance.state = [SPUpdaterState lastState];
        instance.info = [[SPInfoManager alloc] init];
    });
    return instance;
}

- (void)setLogOutputTextView:(NSTextView *)textView
{
    [SPLogHelper setLogOutputTextView:textView];
}

#pragma mark - Timer
- (void)resetTimer
{
    [self cancelTimer];
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, kUpdateDuration * NSEC_PER_SEC, 0);
    dispatch_block_t block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [self checkUpdate];
    });
    dispatch_source_set_event_handler(timer, block);
    dispatch_resume(timer);
    self.timer = timer;
    self.timerBlock = block;
}

- (void)cancelTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    if (self.timerBlock) {
        dispatch_block_cancel(self.timerBlock);
        self.timerBlock = nil;
    }
}

- (void)start
{
    [self resetTimer];
}

- (void)stop
{
    [self cancelTimer];
}

#define NEED_UPDATE 1
#define NOT_UPDATE 0
#define CHECK_FAILED -1

#pragma mark - CheckUpdate
- (void)checkUpdate
{
    SPLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    SPLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    SPLog(@"开始检查更新");
    
    // Step 1
    // 检查 items_game_url 是否有更新
    
    self.state.lastCheckTime = [[NSDate date] timeIntervalSince1970];
    self.state.nextCheckTime = self.state.lastCheckTime + kUpdateDuration;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int c1 = [self checkDotaUpdate];
        int c2 = [self checkItemGameURLUpdate];
        
        if (c1 == CHECK_FAILED || c2 == CHECK_FAILED ) {
            // 在其他地方退出了
            return;
        }
        
        if (c1 || c2) {
            SPLog(@"开始更新流程");
            [self beginUpdate];
        }else{
            SPLog(@"不需要更新。等待下次检查");
            [self waitNextCheck];
        }
    });
}

- (int)checkItemGameURLUpdate
{
    NSString *latestURL = [self.info latestItemGameURL];
    if (!latestURL || latestURL.length == 0) {
        [self checkUpdateFailed:@"获取items_game_url失败。停止更新。"];
        return CHECK_FAILED;
    }
    
    BOOL needUpdate = ![self.state.url isEqualToString:latestURL];
    self.state.url = latestURL;
    return needUpdate ? NEED_UPDATE : NOT_UPDATE;
}

- (int)checkDotaUpdate
{
    // Step 2
    // 检查游戏版本是否有更新
    long long lastupdate = NSNotFound;
    long long buildid = NSNotFound;
    BOOL ok = [self.info latestDotaInfo:&lastupdate buildid:&buildid];
    if (!ok) {
        [self checkUpdateFailed:@"检查游戏版本出错了。更新中断。"];
        return CHECK_FAILED;
    }

    BOOL c1 = lastupdate != self.state.dota2LastUpdated;
    BOOL c2 = buildid != self.state.dota2Buildid;
    
    self.state.dota2Buildid = buildid;
    self.state.dota2LastUpdated = lastupdate;
    
    return (c1 || c2) ? NEED_UPDATE : NOT_UPDATE;
}

- (void)checkUpdateFailed:(NSString *)msg
{
    SPLog(@"%@",msg);
    [self.state reset];
    [self.info reset];
    [self waitNextCheck];
}

- (void)waitNextCheck
{
    [self.state save];
    SPLog(@"等待下次检查更新");
    SPLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    SPLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
}

#pragma mark - Begin Update

- (void)updateFailed:(NSString *)msg
{
    SPLog(@"%@",msg);
    [self.info reset];
    // TODO 其他 reset 操作
    [self waitNextCheck];
}


- (void)updateDone
{
    [self.info saveItemGameURL:self.info.tmpURL lastUpdate:self.info.tmpLastUpdate buildid:self.info.tmpBuildid baseDataVersion:nil];
    [self waitNextCheck];
}

- (void)beginUpdate
{
    // Step 3
    // 开始更新流程
    
    SPLog(@"读取语言文件");
    BOOL suc = [SPLocalMapping updateLangDataIfNeed:kSPLanguageSchinese];
    if (!suc){
        [self updateFailed:@"读取语言文件失败"];
        return;
    }
    
    // 从steam服务器下载饰品数据
    SPLog(@"获取 饰品基础数据 ");

    NSURL *URL = [NSURL URLWithString:self.state.url];
    NSString *name = [URL lastPathComponent];
    
    NSString *path = [[SPPathManager downloadPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        SPLog(@"items_game_url 文件已存在，跳过下载过程。开始解析。");
        NSData *data = [NSData dataWithContentsOfFile:path];
        VDFNode *node = [VDFParser parse:data];
        [self parseItemsGameData:node];
        
    }else{
        SPLog(@"准备下载 items_game.txt");
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        
        AFURLSessionManager *manager = [AFURLSessionManager new];
        
        NSURLSessionDownloadTask *task =
        [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
            
            long long total = downloadProgress.totalUnitCount;
            double downloaded = downloadProgress.completedUnitCount;
            int progress = downloaded / total * 100;
            SPLog(@"%d%%\t%.0f\t/\t%lld",progress,downloaded,total);
            
        } destination:^NSURL *(NSURL * targetPath, NSURLResponse *response) {
            
            NSString *path = [[SPPathManager downloadPath] stringByAppendingPathComponent:name];
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            if (error) {
                [self updateFailed:error.localizedDescription];
                return;
            }
            
            SPLog(@"下载items_game.txt结束，文件保存到：%@",filePath);
            SPLog(@"开始解析");
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            VDFNode *node = [VDFParser parse:data];
            [self parseItemsGameData:node];
            
        }];
        [task resume];
        self.manager = manager;
    }
}

- (void)parseItemsGameData:(VDFNode *)node
{
    SPLog(@"step3：创建数据model");
    BOOL suc = [[SPItemGameData shared] dataWithRootNode:[node firstChildWithKey:@"items_game"]];
    if (!suc) {
        [self updateFailed:@"创建数据model出错！中断。"];
        return;
    }
    
    SPLog(@"step4：创建数据文件");
    suc = [[SPItemGameData shared].model save];
    if (!suc) {
        [self updateFailed:@"创建数据文件出错！中断。"];
        return;
    }
    
    // 将数据库上传到服务器
    // none -> old -> ad -> pro -> 完成
    [self uploadToServiceNextOf:ServiceTypeOld];
}

- (void)uploadToServiceNextOf:(ServiceType)type
{
    ServiceType next = kNoneType;
    if (type == kNoneType) {
        next = ServiceTypeOld;
    }else if (type == ServiceTypeOld){
        next = ServiceTypeAd;
    }else if (type == ServiceTypeAd){
        next = ServiceTypePro;
    }else if (type == ServiceTypePro){
        next = kDoneType;
    }
    
    if (next == kNoneType) return;
    
    if (next == kDoneType) {
        [self updateDone];
        return;
    }
    
    [self uploadToService:next];
}

- (void)uploadToService:(ServiceType)type
{
    SPLog(@"准备上传 %@ 的数据",logStringForServiceType(type));
    
    NSString *appid = appidForServiceType(type);
    NSString *appkey = keyForServiceType(type);
    
    [AVOSCloud setApplicationId:appid clientKey:appkey];
    [AVOSCloud setAllLogsEnabled:NO];
    
    [self upload:type];
}

- (void)upload:(ServiceType)type
{
    SPLog(@"准备更新语言文件");
    
    
    [self uploadLangFileTo:type completion:^(ServiceType type2) {
        
        
        [self uploadLangPatchFileTo:type2 completion:^(ServiceType type3) {
            
            
            [self uploadBaseData:type3];
            
            
        }];
        
        
    }];
    
}

- (void)uploadLangFileTo:(ServiceType )type
              completion:(void (^)(ServiceType type))completion
{
    SPLog(@"检查主语言文件更新");
    
    NSString *lang = kSPLanguageSchinese;
    long long langVersion = 0;
    AVObject *langVersionObject;
    {
        NSError *error;
        AVQuery *query = [AVQuery queryWithClassName:@"Version"];
        [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_version_%@",lang]];
        AVObject *object = [query findObjects:&error].firstObject;
        if (!object || error) {
            [self updateFailed:[NSString stringWithFormat:@"检查主语言文件版本出错！%@",error]];
            return;
        }
        langVersion = [[object objectForKey:@"version"] longLongValue];
        SPLog(@"服务器主语言版本： %lld",langVersion);
        langVersionObject = object;
    }
    
    {
        long long curLangVersion = [[SPLocalMapping langVersion][lang] longLongValue];
        SPLog(@"新的主语言文件版本为:%lld",curLangVersion);
        if (curLangVersion <= langVersion) {
            SPLog(@"不需要更新主语言文件");
            if (completion) {
                completion(type);
            }
            return;
        }
        SPLog(@"上传主语言文件 开始");
        {
            NSString *langMainFilePath = [SPLocalMapping langMainFileZipPath:kSPLanguageSchinese];
            AVFile *file = [AVFile fileWithName:langMainFilePath.lastPathComponent contentsAtPath:langMainFilePath];
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if ( !succeeded || error) {
                    [self updateFailed:[NSString stringWithFormat:@"上传主语言文件失败！%@",error]];
                    return;
                }
                
                SPLog(@"上传主语言文件 完成");
                SPLog(@"更新主文件版本号为：%lld",curLangVersion);
                [langVersionObject setObject:@(curLangVersion) forKey:@"version"];
                BOOL suc = [langVersionObject save:&error];
                
                if (!suc || error) {
                    [self updateFailed:[NSString stringWithFormat:@"上传主语言文件版本号失败！%@",error]];
                    return;
                }
                
                SPLog(@"更新主语言文件 结束");
                if (completion) {
                    completion(type);
                }
            } progressBlock:^(NSInteger percentDone) {
                SPLog(@"上传主语言文件：%d%%",(int)percentDone);
            }];
        }
    }
}

- (void)uploadLangPatchFileTo:(ServiceType)type
                   completion:(void(^)(ServiceType type))completion
{
    SPLog(@"检查语言补丁更新");
    
    NSString *lang = kSPLanguageSchinese;
    long long langPatchVersion = 0;
    AVObject *langPatchVersionObject;
    
    {
        NSError *error;
        AVQuery *query = [AVQuery queryWithClassName:@"Version"];
        [query whereKey:@"name" equalTo:[NSString stringWithFormat:@"lang_patch_version_%@",lang]];
        AVObject *object = [query findObjects:&error].firstObject;
        if (!object || error) {
            [self updateFailed:[NSString stringWithFormat:@"检查语言补丁版本出错！%@",error]];
            return;
        }
        langPatchVersion = [[object objectForKey:@"version"] longLongValue];
        SPLog(@"服务器语言补丁版本： %lld",langPatchVersion);
        langPatchVersionObject = object;
    }
    
    {
        long long curLangPatchVersion = [[SPLocalMapping langVersion][[NSString stringWithFormat:@"%@_patch",lang]] longLongValue];
        SPLog(@"新的语言补丁版本为:%lld",curLangPatchVersion);
        if (curLangPatchVersion <= langPatchVersion) {
            SPLog(@"不需要更新语言补丁文件");
            if (completion) {
                completion(type);
            }
            return;
        }
        
        SPLog(@"上传语言补丁文件 开始");
        {
            NSString *langPatchFilePath = [SPLocalMapping langPatchFileZipPath:kSPLanguageSchinese];
            AVFile *file = [AVFile fileWithName:langPatchFilePath.lastPathComponent contentsAtPath:langPatchFilePath];
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if ( !succeeded || error) {
                    [self updateFailed:[NSString stringWithFormat:@"上传语言补丁文件失败！%@",error]];
                    return;
                }
                
                SPLog(@"上传语言补丁 完成");
                SPLog(@"更新语言补丁版本号为：%lld",curLangPatchVersion);
                
                [langPatchVersionObject setObject:@(curLangPatchVersion) forKey:@"version"];
                BOOL suc = [langPatchVersionObject save:&error];
                if (!suc || error) {
                    [self updateFailed:[NSString stringWithFormat:@"上传语言补丁文件版本号失败！%@",error]];
                    return;
                }
                
                SPLog(@"更新语言补丁 结束");
                
                
                if (completion) {
                    completion(type);
                }
                
            } progressBlock:^(NSInteger percentDone) {
                SPLog(@"上传语言补丁：%d%%",(int)percentDone);
            }];
            
        }
    }
}

- (void)uploadBaseData:(ServiceType)type
{
    SPLog(@"准备上传基础数据");
    {
        NSString *dataPath = [[[SPItemGameData shared] model] zipFilePath];
        AVFile *file = [AVFile fileWithName:dataPath.lastPathComponent contentsAtPath:dataPath];
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if ( !succeeded || error) {
                [self updateFailed:[NSString stringWithFormat:@"上传基础数据文件失败！%@",error]];
                return;
            }
            
            SPLog(@"准备上传基础数据版本");
            {
                NSNumber *version = [[SPItemGameData shared].model version][@"version"];
                
                AVQuery *query = [AVQuery queryWithClassName:@"Version"];
                [query whereKey:@"name" equalTo:@"base_data_version"];
                AVObject *object = [query findObjects:&error].firstObject;
                if (!object || error) {
                    [self updateFailed:[NSString stringWithFormat:@"获取基础数据版本出错！%@",error]];
                    return;
                }
                
                [object setObject:version forKey:@"version"];
                BOOL suc = [object save:&error];
                if (!suc || error) {
                    [self updateFailed:[NSString stringWithFormat:@"上传基础数据版本出错！%@",error]];
                    return;
                }
                
                SPLog(@"done");
            }
            
            NSString *logString = logStringForServiceType(type);
            SPLog(@"%@ 更新完成！！",logString);
            
            
            // 发送推送通知
            NSInteger addCount = [SPItemGameData shared].model.addCount;
            NSInteger modifyCount = [SPItemGameData shared].model.modifyCount;
            // TODO
            
            [self uploadToServiceNextOf:type];
            
            
        } progressBlock:^(NSInteger percentDone) {
            SPLog(@"%d%%",(int)percentDone);
        }];
    }
}

@end
