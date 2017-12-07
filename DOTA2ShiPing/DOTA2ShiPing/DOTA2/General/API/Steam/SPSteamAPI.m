//
//  SPSteamAPI.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSteamAPI.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "SPPlayer.h"

#import "SPPlayerItems.h"
#import "YYCategories.h"
#import "SPHTMLSerializer.h"

@interface SPJsonSerializer : AFJSONResponseSerializer
@end

@interface NSURLResponse (MD5)
// 数据 NSData 的MD5值
@property (strong, nonatomic) NSString *MD5;
@end

static void *kNSURLResponseMD5Key = &kNSURLResponseMD5Key;
@implementation NSURLResponse (MD5)
- (NSString *)MD5
{
    return objc_getAssociatedObject(self, kNSURLResponseMD5Key);
}

- (void)setMD5:(NSString *)MD5
{
    objc_setAssociatedObject(self, kNSURLResponseMD5Key, MD5, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end

@interface SPSteamAPI ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSURL *cookieRequestURL;

@property (strong, nonatomic) AFHTTPSessionManager *webAPIManager;
@property (strong, nonatomic) AFHTTPSessionManager *workshopManager;
@property (strong, nonatomic) AFHTTPSessionManager *marketManager;
@end

@implementation SPSteamAPI

+ (instancetype)shared
{
    static SPSteamAPI *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPSteamAPI new];
        shared.cookieRequestURL = [NSURL URLWithString:@"http://steamcommunity.com/search"];
        
        NSURL *baseURL = [NSURL URLWithString:@"http://steamcommunity.com"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1" forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
        [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
        shared.manager = manager;
        
        NSURL *webapiBaseURL = [NSURL URLWithString:@"http://api.steampowered.com"];
        AFHTTPSessionManager *webapiManager = [[AFHTTPSessionManager alloc] initWithBaseURL:webapiBaseURL];
        [webapiManager setResponseSerializer:[SPJsonSerializer new]];
        shared.webAPIManager = webapiManager;
    });
    return shared;
}

- (AFHTTPSessionManager *)workshopManager
{
    if (!_workshopManager) {
        NSURL *baseURL = [NSURL URLWithString:@"http://steamcommunity.com"];
        _workshopManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _workshopManager.responseSerializer = [[SPHTMLSerializer alloc] init];
        
        [_workshopManager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1" forHTTPHeaderField:@"User-Agent"];
        [_workshopManager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
        [_workshopManager.requestSerializer setValue:@"http://steamcommunity.com/app/570/workshop/" forHTTPHeaderField:@"Referer"];
    }
    return _workshopManager;
}

- (AFHTTPSessionManager *)marketManager
{
    if (!_marketManager) {
        NSURL *baseURL = [NSURL URLWithString:@"http://steamcommunity.com"];
        _marketManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _marketManager.responseSerializer = [[SPHTMLSerializer alloc] init];
        
        AFHTTPRequestSerializer *reqSerializer = _marketManager.requestSerializer;
        [reqSerializer setValue:@"steamcommunity.com" forHTTPHeaderField:@"Host"];
        [reqSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        [reqSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [reqSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Mobile/14G60" forHTTPHeaderField:@"User-Agent"];
        [reqSerializer setValue:@"http://steamcommunity.com" forHTTPHeaderField:@"Referer"];
        [reqSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSMutableSet *types = [NSMutableSet setWithSet:_marketManager.responseSerializer.acceptableContentTypes];
        [types addObject:@"application/json"];
        _marketManager.responseSerializer.acceptableContentTypes = types;
    }
    return _marketManager;
}

- (NSDictionary *)defaultWebAPIParams
{
    static NSArray *kAPIKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kAPIKeys = @[@"CD9010FD71FA1583192F9BDB87ED8164"
                     ,@"D46675A241E560655ABD306C2A275D60"];
    });
    
    return @{@"key":        kAPIKeys[arc4random_uniform(2)],
             @"format":     @"json",
             @"language":   @"zh_cn",
             @"appid":      @570};
}

#pragma mark -
- (void)getCookiesWithComletion:(void (^)(NSArray *))completion
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:self.cookieRequestURL];
    if (cookies.count == 0) {
        void (^callCompletion)(void) = ^{
            completion?completion([cookieStorage cookiesForURL:self.cookieRequestURL]):nil;
        };
        [self.manager HEAD:@"search" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
            callCompletion();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callCompletion();
        }];
    }else{
        completion(cookies);
    }
}

- (void)handleSearchResult:(NSDictionary *)object
                completion:(SPSteamSearchUserCompletion)completion
{
    if (!completion) {
        return;
    }
    if (!object || ![object isKindOfClass:[NSDictionary class]]) {
        completion(NO,nil,@"出错了");
        return;
    }
    
    NSString *html = object[@"html"];
    html = [NSString stringWithFormat:@"<html><body>%@</body></html>",html];
    TFHpple *hpple = [TFHpple hppleWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *searchRows = [hpple searchWithXPathQuery:@"//div[@class='search_row']"];
    
    NSMutableArray *result = [NSMutableArray array];
    for (TFHppleElement *element in searchRows) {
        
        TFHppleElement *steamidNode = [element firstChildWithClassName:@"mediumHolder_default"];
        
        NSString *playerId = steamidNode.attributes[@"data-miniprofile"];
        
        TFHppleElement *imgNode = [[[steamidNode firstChildWithClassName:@"avatarMedium"] firstChildWithTagName:@"a"] firstChildWithTagName:@"img"];
        NSString *playerAvatar = imgNode.attributes[@"src"];
        
        TFHppleElement *nameNode = [[element firstChildWithClassName:@"searchPersonaInfo"] firstChildWithClassName:@"searchPersonaName"];
        NSString *name = nameNode.text;
        
        SPPlayer *player = [SPPlayer new];
        player.steam_id = @([playerId longLongValue]);
        player.name = name;
        player.avatar_url = playerAvatar;
        
        [result addObject:player];
    }
    
    completion(YES,result,nil);
}

- (void)searchUser:(NSString *)keywords
        completion:(SPSteamSearchUserCompletion) completion
{
    ygweakify(self);
    [self getCookiesWithComletion:^(NSArray *cookies) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"filter"] = @"users";
        params[@"steamid_user"] = @"false";
        params[@"text"] = keywords;

        for (NSHTTPCookie *cookie in cookies) {
            NSString *name = cookie.name;
            NSString *value = cookie.value;
            params[name] = value;
        }
        
        ygstrongify(self);
        [self.manager GET:@"search/SearchCommunityAjax" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            ygstrongify(self);
            [self handleSearchResult:responseObject completion:completion];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            ygstrongify(self);
            [self handleSearchResult:nil completion:completion];
        }];
    }];
}

#pragma mark - 
- (void)fetchPlayerItems:(NSNumber *)steamid17
              completion:(void (^)(SPPlayerItemsList *))completion
{
    if (!steamid17 || !completion) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self defaultWebAPIParams]];
    params[@"steamid"] = steamid17;
//    params[@"steamid"] = @"76561198059579364";
    
    void (^failure)(void) = ^{
        SPPlayerItemsList *list = [SPPlayerItemsList new];
        list.status = SPPlayerItemsListStatusFailure;
        completion(list);
    };
    
    [self.webAPIManager setResponseSerializer:[[SPJsonSerializer alloc] init]];
    [self.webAPIManager GET:@"IEconItems_570/GetPlayerItems/v0001" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = responseObject[@"result"];
            SPPlayerItemsList *list = [SPPlayerItemsList yy_modelWithDictionary:result];
            list.MD5 = task.response.MD5;
            completion(list);
        }else{
            failure();
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

- (void)fetchInventoryOfUser:(NSNumber *)steamid17
                   fromIndex:(NSUInteger)index
                  completion:(SPSteamFetchCompletion)completion
{
    if (!steamid17 || !completion) {
        return;
    }
    
    // 另外一个类似接口
    // http://steamcommunity.com/inventory/76561198093553906/570/2?l=schinese&count=75
    
    NSString *url = [NSString stringWithFormat:@"profiles/%@/inventory/json/570/2",steamid17];
    NSDictionary *params = @{@"l":@"zh_CN",@"start":@(index)};
    
    SPLog(@"开始请求 start: %lu",(unsigned long)index);
    
    [self.manager GET:url parameters:params progress:^(NSProgress *downloadProgress) {
        
        NSInteger c = downloadProgress.completedUnitCount;
        NSInteger t = downloadProgress.totalUnitCount;
        
        SPLog(@"%ld/%ld  %.2f%%",(long)c,t,100*c/(CGFloat)t);
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSDictionary *convert;
        {
            NSDictionary *rgInventory = dic[@"rgInventory"];
            NSDictionary *rgDescriptions = dic[@"rgDescriptions"];
            
            NSMutableArray *items = [NSMutableArray array];
            for (NSDictionary *aItem in [rgInventory allValues]) {
                NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:aItem];
                NSString *k = [NSString stringWithFormat:@"%@_%@",tmp[@"classid"],tmp[@"instanceid"]];
                NSDictionary *rgDescriptionDict = rgDescriptions[k];
                if (!rgDescriptionDict) {
                    // 这里需要考虑多页的情况。如果多页的条件下 k 对应的 rgDescription 在其他页，就需要重写了。
                    SPLog(@"123123123");
                }else{
                    [tmp addEntriesFromDictionary:rgDescriptionDict];
                }
                
                [items addObject:tmp];
            }
            
            [items sortUsingComparator:^NSComparisonResult(NSDictionary *obj1,NSDictionary *obj2) {
                NSUInteger pos1 = [obj1[@"pos"] integerValue];
                NSUInteger pos2 = [obj2[@"pos"] integerValue];
                return [@(pos1) compare:@(pos2)];
            }];
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dic];
            mDict[@"items"] = items;
            mDict[@"rgInventory"] = nil;
            mDict[@"rgDescriptions"] = nil;
            convert = mDict;
        }
        
        SPPlayerInventory *inventory = [SPPlayerInventory yy_modelWithDictionary:convert];
        completion(YES,inventory);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,nil);
    }];
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSDictionary *header = [HTTPResponse allHeaderFields];
        long long length = [header[@"Content-Length"] longLongValue];
        SPLog(@"文件长度：%lld",length);
        return NSURLSessionResponseAllow;
    }];
}

- (void)fetchPlayerInventory:(NSNumber *)steamid17
                  itemsCount:(NSNumber *)count
                    progress:(void (^)(NSProgress *progress))p
                  completion:(SPSteamFetchCompletion)completion
{
    if (!completion || !steamid17) return;
    
    __block NSProgress *theProgress;
    if (count) {
        NSUInteger pages = ceilf(count.integerValue/2000.f);
        theProgress = [NSProgress progressWithTotalUnitCount:pages];
    }
    __block NSMutableArray *inventories = [NSMutableArray array];
    
    static void (^Recursion)(NSUInteger idx);

    Recursion = ^(NSUInteger idx){
        
        SPLog(@"准备请求：第 %lld 页",theProgress.completedUnitCount);
        
        [self fetchInventoryOfUser:steamid17 fromIndex:idx completion:^(BOOL suc, id object) {
            
            // 网络错误
            if (!suc){
                SPLog(@"网络错误!");
                completion(NO,@"网络错误");
                return;
            }
            
            // 数据错误
            SPPlayerInventory *inventory = object;
            if (!inventory || !inventory.success.boolValue) {
                SPLog(@"数据错误!");
                completion(NO,@"数据错误");
                return;
            }
            [inventories addObject:inventory];
            BOOL more = inventory.more.boolValue;
            NSUInteger moreStart = inventory.more_start.integerValue;
            
            SPLog(@"本次获取完成 moreStart: %lu",(unsigned long)moreStart);
            
            // 还有下一页
            if (more && moreStart > idx) {
                
                SPLog(@"第 %lld 页 请求完成",theProgress.completedUnitCount);
                
                RunOnMainQueue(^{
                    // 进度回调
                    if (p && theProgress) {
                        [theProgress setCompletedUnitCount:theProgress.completedUnitCount+1];
                        p(theProgress);
                    }
                });
                
                // 继续请求下一页
                Recursion(moreStart);
            }else {
                
                SPLog(@"全部数据请求完成！！！！！！回调");
                
                // 库存拉取完成。合并后返回。
                SPPlayerInventory *final = [SPPlayerInventory merge:inventories];
                completion(YES,final);
                return;
            }
        }];
    };
    
    // 递归调用 直到库存数据全部获取完成
    Recursion(0);
}

- (void)fetchPlayerSummaries:(NSArray *)steamid17s
                  completion:(SPSteamFetchCompletion)completion
{
    NSMutableDictionary *params = [self defaultWebAPIParams].mutableCopy;
    params[@"steamids"] = [steamid17s componentsJoinedByString:@","];
    
    [self.webAPIManager GET:@"ISteamUser/GetPlayerSummaries/v0002" parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *playersJson = responseObject[@"response"][@"players"];
            NSArray *players = [NSArray yy_modelArrayWithClass:[SPPlayerDetailInfo class] json:playersJson];
            completion(players,players);
        }else{
            completion(NO,@"数据错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(NO,@"网络错误");
    }];
}

- (void)fetchPlayerSummarie:(NSNumber *)steamid17
                  completion:(SPSteamFetchCompletion)completion
{
    if (!steamid17 || !completion) return;
    return [self fetchPlayerSummaries:@[steamid17] completion:^(BOOL suc, id object) {
        if ([object isKindOfClass:[NSArray class]]) {
            completion(suc,[object firstObject]);
        }else{
            completion(suc,object);
        }
    }];
}

- (void)fetchPlayerAliases:(NSNumber *)steamid17
                completion:(SPSteamFetchCompletion)completion
{
    if (!steamid17 || !completion) return;
    
    NSString *url = [NSString stringWithFormat:@"profiles/%@/ajaxaliases/",steamid17];
    [self.manager GET:url parameters:nil progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[SPPlayerAliase class] json:responseObject];
            completion(YES,list);
        }else{
            completion(NO,@"数据错误");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,@"网络错误");
    }];
}

- (void)fetchPlayerFriends:(NSNumber *)steamid17
                completion:(SPSteamFetchCompletion)completion
{
    if (!steamid17 || !completion) return;
    
    NSMutableDictionary *params = [self defaultWebAPIParams].mutableCopy;
    params[@"steamids"] = steamid17;
    
    [self.webAPIManager GET:@"ISteamUser/GetFriendList/v1" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *friendsJson = responseObject[@"friendslist"][@"friends"];
            NSArray *friends = [NSArray yy_modelArrayWithClass:[SPPlayerFriend class] json:friendsJson];
            completion(nil!=friends,friends);
        }else{
            completion(NO,@"数据错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(NO,@"网络错误");
    }];
}

- (NSURLSessionDataTask *)fetchWorkShopContent:(NSDictionary *)query
                                      progress:(void (^)(NSProgress *progress))progress
                                    completion:(SPSteamFetchCompletion2)completion
{
    if (!completion) return nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:query];
    params[@"appid"] = @570;
    
    return
    [self.workshopManager GET:@"workshop/browse" parameters:params progress:progress success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(nil!=responseObject,responseObject,task.taskDescription);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,@"网络错误",task.taskDescription);
    }];
}

- (NSURLSessionDataTask *)fetchWorkshopDetail:(NSNumber *)itemid
                                   completion:(SPSteamFetchCompletion2)completion
{
    if (!completion || !itemid) return nil;
    
    return
    [self.workshopManager GET:@"sharedfiles/filedetails" parameters:@{@"id":itemid} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(nil!=responseObject,responseObject,task.taskDescription);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,@"网络错误",task.taskDescription);
    }];
}

- (void)workshopImageTest:(NSURL *)imageURL
               completion:(void (^)(BOOL suc, NSUInteger size))completion
{
    if (!completion) return;
    
    [[AFHTTPSessionManager manager] HEAD:imageURL.absoluteString parameters:nil success:^(NSURLSessionDataTask *task) {
        
        NSHTTPURLResponse *response = task.response;
        
        NSUInteger len = response.expectedContentLength;
        
        completion(YES,len);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO,-1);
    }];
}

- (void)fetchSteamPriceOverview:(NSString *)itemName
                     completion:(SPSteamFetchCompletion2)completion
{
    if (!itemName || !completion) return;
    
    NSDictionary *param = @{@"market_hash_name":itemName,
                            @"appid":@"570",
                            @"country":@"CN",
                            @"currency":@"23"};
    
    RunOnGlobalQueue(^{
       
        NSURLComponents *components = [NSURLComponents componentsWithString:@"http://steamcommunity.com/market/priceoverview"];
        NSMutableArray *query = [NSMutableArray array];
        for (NSString *k in param) {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:k value:param[k]];
            [query addObject:item];
        }
        components.queryItems = query;

        [[[NSURLSession sharedSession] dataTaskWithURL:components.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            NSInteger code = resp.statusCode;
            RunOnMainQueue(^{
                if (code == 429) {
                    completion(NO,@"请求频繁",nil);
                }else if (!error){
                    completion(YES,data,nil);
                }else{
                    completion(NO,@"网络错误",nil);
                }
            });
        }] resume];
    });
}

- (void)fetchSteamPriceList:(NSString *)itemName
                     pageNo:(NSInteger)pageNo
                 completion:(SPSteamFetchCompletion2)completion
{
    
//    http://steamcommunity.com/market/search/render/?query=信仰&start=0&count=10&search_descriptions=0&sort_column=default&sort_dir=desc&appid=570
    
    if (!itemName || !completion) return;
    
    NSDictionary *param = @{@"query":itemName,
                            @"appid":@"570",
                            @"start":[@(pageNo*10) stringValue],
                            @"count":@"10",
                            @"sort_column":@"default",
                            @"sort_dir":@"desc",
                            @"search_descriptions":@"0"
                            };
    
    RunOnGlobalQueue(^{
        
        NSURLComponents *components = [NSURLComponents componentsWithString:@"http://steamcommunity.com/market/search/render"];
        NSMutableArray *query = [NSMutableArray array];
        for (NSString *k in param) {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:k value:param[k]];
            [query addObject:item];
        }
        components.queryItems = query;
        
        [[[NSURLSession sharedSession] dataTaskWithURL:components.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            NSInteger code = resp.statusCode;
            RunOnMainQueue(^{
                if (code == 429) {
                    completion(NO,@"请求频繁",nil);
                }else if (!error){
                    completion(YES,data,nil);
                }else{
                    completion(NO,@"网络错误",nil);
                }
            });
        }] resume];
    });
}

- (NSURLSessionDataTask *)fetchSteamMarketContent:(NSString *)itemName
                                       completion:(SPSteamFetchCompletion2)completion
{
    if (!itemName || !completion) return nil;
    
    return
    [self.marketManager GET:@"market/search" parameters:@{@"q":itemName,@"appid":@570,@"l":@"schinese"} progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(nil!=responseObject,responseObject,task.taskDescription);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]] && response.statusCode == 429) {
            SPLog(@"%@", response.allHeaderFields);
            completion(NO,@"您最近作出的请求太多了。请稍候再重试您的请求。",task.taskDescription);
        }else{
            completion(NO,@"网络错误",task.taskDescription);
        }
    }];
}

- (void)fetchSteamMarketItemDetail:(NSString *)url
                        completion:(SPSteamFetchCompletion)completion
{
    if (!url || !completion) return ;
    
    RunOnGlobalQueue(^{
        NSError *error;
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
        
        RunOnMainQueue(^{
            if (error) {
                completion(NO,@"网络错误");
            }else{
                completion(YES,string);
            }
        });
    });
}

@end

@implementation SPLocation
@end

#pragma mark - SPJsonSerializer

#include <iconv.h>

@interface SPJsonSerializer ()
@end

@implementation SPJsonSerializer
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id object = [super responseObjectForResponse:response data:data error:error];
    
    response.MD5 = data.md5String;
    if ( *error && (*error).code == 3840) { // 3840为 NSJsonSerialization 无法解析json时的错误码
        NSData *theData = [self cleanUTF8:data];
        if (theData && theData.length > 0) {
            *error = nil;
            object = [NSJSONSerialization JSONObjectWithData:theData options:self.readingOptions error:error];
            response.MD5 = theData.md5String;
        }
    }
    return object;
}

- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从utf8转utf8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 丢弃不正确的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        SPLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}

@end


