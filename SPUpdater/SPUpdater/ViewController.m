//
//  ViewController.m
//  SPUpdater
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "ViewController.h"
#import "VDFParser.h"
#import "SPLocalMapping.h"
#import "SPItemGameData.h"
#import <AFNetworking.h>
#import "SPVDFResponseSerializer.h"
#import "SPItemImageDownloader.h"
#import "SPHeroImageDownloader.h"
#import <SSZipArchive.h>
#import <AVOSCloud.h>
#import "SPPathManager.h"

typedef NS_ENUM(NSInteger, ServiceType) {
    ServiceTypeOld,
    ServiceTypePro,
    ServiceTypeAd,
};

static ServiceType kNoneType = -1;

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

#import <AFNetworking.h>

static ViewController *sharedVC;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSTextView *textView;
@property (strong, nonatomic) AFURLSessionManager *manager;
@end

void SPLog(NSString *format, ...){
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
    NSString *text = [[NSString alloc] initWithFormat:format arguments:args];
    dispatch_async(dispatch_get_main_queue(), ^{
        sharedVC.textView.string = [[text stringByAppendingString:@"\n"] stringByAppendingString:sharedVC.textView.string];
    });
}

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedVC = self;
    
    //    // 下载图片。需要先生成数据库
    //    [SPItemImageDownloader compressImages];
    //    [SPItemImageDownloader download:@"/Users/wangbo/Desktop/DOTA.tmp/basedata/item.db"];
    //    return;
    
    //    // 下载英雄头像
    //    [SPHeroImageDownloader downloadImages];
    //    return;
    
    
    // 第一步：从Dota2游戏文件中提取语言文件
    SPLog(@"step1：语言文件");
    [SPLocalMapping updateLangDataIfNeed:kSPLanguageSchinese];
    
    // 跳过第二步，使用download中的 items_game文件
//    SPLog(@"跳过 step2");
//    [self test];
//    return;
    
    // 第二步：从steam服务器下载饰品数据
    SPLog(@"step2: 获取 schemaURL ");
    NSString *apiURL = @"https://api.steampowered.com/IEconItems_570/GetSchemaURL/v1?key=CD9010FD71FA1583192F9BDB87ED8164";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiURL]];
    NSAssert(data, @"获取schemaURL失败！");
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSAssert(json, @"items_game数据错误");
    
    NSString *items_game_url = json[@"result"][@"items_game_url"];
    SPLog(@"items_game_url: %@",items_game_url);
    NSURL *URL = [NSURL URLWithString:items_game_url];
    NSString *name = [URL lastPathComponent];
    
    NSString *path = [[SPPathManager downloadPath] stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSLog(@"items_game_url 文件已存在，跳过下载过程");
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        VDFNode *node = [VDFParser parse:data];
        [self parseItemsGameData:node];
        
    }else{
        NSLog(@"准备下载 items_game.txt");
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
            if (progress % 10 == 0) {
                SPLog(@"%.0f%%, total: %lld",total);
            }
            
        } destination:^NSURL *(NSURL * targetPath, NSURLResponse *response) {
            
            NSString *path = [[SPPathManager downloadPath] stringByAppendingPathComponent:name];
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            NSAssert(!error, @"下载items_game.txt出错了");
            NSLog(@"下载items_game.txt结束，开始解析。");
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            VDFNode *node = [VDFParser parse:data];
            [self parseItemsGameData:node];

        }];
        [task resume];
        self.manager = manager;
    }
}

- (void)test
{
    NSString *path = [SPPathManager downloadPath];
    NSArray *paths = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *items_game_path;
    NSDate *lastDate = [NSDate distantPast];
    
    for (NSString *aFile in paths) {
        NSString *aPath = [path stringByAppendingPathComponent:aFile];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:aPath error:nil];
        NSDate *date = attributes[NSFileModificationDate];
        if (date && [date compare:lastDate] == NSOrderedDescending) {
            lastDate = date;
            items_game_path = aPath;
        }
    }
    
    VDFNode *node = [VDFParser parse:[NSData dataWithContentsOfFile:items_game_path]];
    [self parseItemsGameData:node];
}

- (void)parseItemsGameData:(VDFNode *)node
{
    SPLog(@"step3：创建数据model");
    [[SPItemGameData shared] dataWithRootNode:[node firstChildWithKey:@"items_game"]];
    
    SPLog(@"step4：创建数据文件");
    [[SPItemGameData shared].model save];
    
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
        next = kNoneType;
    }
    
    if (next == kNoneType) return;
    
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
        NSAssert(object && !error, @"出错了！");
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
                NSAssert(!error, @"出错了！");
                
                SPLog(@"上传主语言文件 完成");
                SPLog(@"更新主文件版本号为：%lld",curLangVersion);
                [langVersionObject setObject:@(curLangVersion) forKey:@"version"];
                BOOL suc = [langVersionObject save:&error];
                
                NSAssert( suc && !error, @"更新版本号出错了！");
                
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
        NSAssert(object && !error, @"出错了！");
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
                
                NSAssert(!error, @"出错了！");
                
                SPLog(@"上传语言补丁 完成");
                SPLog(@"更新语言补丁版本号为：%lld",curLangPatchVersion);
                
                [langPatchVersionObject setObject:@(curLangPatchVersion) forKey:@"version"];
                BOOL suc = [langPatchVersionObject save:&error];
                NSAssert(suc && !error, @"出错了!");
                
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
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            [file save:&error];
            NSAssert(!error, @"出错了！");
            SPLog(@"done");
            
            SPLog(@"准备上传基础数据版本");
            {
                NSNumber *version = [[SPItemGameData shared].model version][@"version"];
                
                AVQuery *query = [AVQuery queryWithClassName:@"Version"];
                [query whereKey:@"name" equalTo:@"base_data_version"];
                AVObject *object = [query findObjects:&error].firstObject;
                NSAssert(object && !error, @"获取版本出错！");
                
                [object setObject:version forKey:@"version"];
                BOOL suc = [object save:&error];
                NSAssert(suc && !error, @"版本保存出错");
                
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
