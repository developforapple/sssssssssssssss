//
//  SPWorkshop.c
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#include "SPWorkshop.h"
#import "SPSteamAPI.h"
#import "SPMacro.h"
#import <TFHpple.h>
#import <YYCache.h>
#import <YYModel.h>
#import <JavaScriptCore/JavaScriptCore.h>

// 缓存
static NSString *const kSPWorkshopCacheName = @"SPWorkshopCache";
static NSTimeInterval const kSPWorkshopExpirTime = 2*60*60;

@interface SPWorkshop ()
@property (strong, nonatomic) YYCache *cache;
@property (strong, readwrite, nonatomic) NSArray *units;     //当前内容
@property (assign, readwrite, nonatomic) BOOL isCacheData;   //当前是否是缓存数据
@property (assign, readwrite, nonatomic) BOOL noMoreData;    //当前是否还有更多数据

@property (strong, readwrite, nonatomic) SPWorkshopQuery *query;

@property (strong, nonatomic) NSURLSessionDataTask *lastTask;

@end

@implementation SPWorkshop

+ (NSInteger)cachedDataSize
{
    YYCache *cache = [YYCache cacheWithName:kSPWorkshopCacheName];
    return [cache.diskCache totalCost];
}

+ (void)clearCachedData:(void (^)(void))completion
{
    YYCache *cache = [YYCache cacheWithName:kSPWorkshopCacheName];
    [cache removeAllObjectsWithBlock:completion];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [YYCache cacheWithName:kSPWorkshopCacheName];
        self.cache.diskCache.ageLimit = kSPWorkshopExpirTime;
        self.isCacheData = NO;
        self.noMoreData = NO;
    }
    return self;
}

- (void)loadQuery:(SPWorkshopQuery *)query ignoreCache:(BOOL)ignore isMore:(BOOL)isMore
{
    if (!query) return;
    
    BOOL willRequest = YES;
    NSArray<SPWorkshopUnit *> *data;
    NSString *cacheKey = [query cacheKey];
    if (!ignore) {
        data = (NSArray *)[self.cache objectForKey:cacheKey];
        willRequest = nil==data;
    }
//TESTTESTESTSTSETSETSETSETSETSETSETSETSETSEES
//    willRequest = YES;
    
    if (willRequest) {
        [self.lastTask cancel];
        
        spweakify(self);
        self.lastTask = [[SPSteamAPI shared] fetchWorkShopContent:[query query] progress:^(NSProgress *progress) {
            spstrongify(self);
            [self progressCallback:progress];
        } completion:^(BOOL suc, id object, NSString *taskDesc) {
            spstrongify(self);
            if (![taskDesc isEqualToString:self.lastTask.taskDescription]) {
                return;
            }
            if (suc) {
                NSArray *units = [self handleFetchResult:object];
                if (isMore) {
                    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.units];
                    [tmp addObjectsFromArray:units];
                    self.units = tmp;
                    self.noMoreData = units.count < query.pageSize;
                }else{
                    self.units = units;
                    self.noMoreData = NO;
                }
                self.isCacheData = NO;
                self.query = query;
                [self callback:YES isMore:isMore];
                
                [self.cache setObject:self.units forKey:cacheKey withBlock:nil];
            }else{
                [self callback:NO isMore:isMore];
            }
        }];
        self.lastTask.taskDescription = cacheKey;
        NSLog(@"Fetch: %@",self.lastTask.currentRequest.URL);
        
    }else{
        NSUInteger count = data.count;
        NSUInteger pages = count/query.pageSize;
        query.pageNo = pages;
        self.units = data;
        self.query = query;
        self.isCacheData = YES;
        self.noMoreData = NO;
        [self callback:YES isMore:NO];
    }
}

- (void)loadWorkshopSection:(SPWorkshopSection)section ignoreCache:(BOOL)ignore
{
    SPWorkshopQuery *query = [[SPWorkshopQuery alloc] init];
    query.section = section;
    [self loadQuery:query ignoreCache:ignore isMore:NO];
}

- (void)sort:(SPWorkshopSort *)sort
{
    SPWorkshopQuery *query = [self.query copy];
    query.sort = sort;
    [self loadQuery:query ignoreCache:NO isMore:NO];
}

- (void)filter:(NSArray<SPWorkshopTag *> *)tags
{
    SPWorkshopQuery *query = [self.query copy];
    query.requiredtags = tags;
    [self loadQuery:query ignoreCache:NO isMore:NO];
}

- (void)loadMore
{
    SPWorkshopQuery *query = [self.query copy];
    query.pageNo++;
    [self loadQuery:query ignoreCache:YES isMore:YES];
}

- (NSArray *)handleFetchResult:(TFHpple *)root
{
    NSArray *itemDivs = [root searchWithXPathQuery:@"//div[contains(@class,'workshopItemPreviewHolder')]"];
    NSArray *titleDivs = [root searchWithXPathQuery:@"//div[contains(@class,'workshopItemTitle')]"];
    NSArray *authorNodes = [root searchWithXPathQuery:@"(//div|//span)[@class='workshopItemAuthorName']"];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (TFHppleElement *divNode in itemDivs) {
        NSUInteger index = [itemDivs indexOfObject:divNode];
        
        NSString *itemId = [divNode objectForKey:@"id"];
        NSString *idStr = [[itemId componentsSeparatedByString:@"_"] lastObject];
        NSNumber *id = @([idStr longLongValue]);
        
        TFHppleElement *imgNode = [divNode firstChildWithTagName:@"img"];
        NSString *imgURL = [imgNode objectForKey:@"src"];
        
        NSString *title;
        if (index < titleDivs.count) {
            TFHppleElement *titleNode = titleDivs[index];
            title = titleNode.text;
        }
        
        NSString *author;
        if (index < authorNodes.count) {
            TFHppleElement *authorNode = authorNodes[index];
            if ([authorNode.tagName isEqualToString:@"div"]) {
                author = [[authorNode firstChildWithTagName:@"a"] text];
            }else{
                author = authorNode.text;
            }
        }
        
        [result addObject:@{@"id":id,
                            @"imageURL":imgURL?:@"",
                            @"title":title?:@"",
                            @"authors":@[author?:@""]}];
    }
    NSArray *units = [NSArray yy_modelArrayWithClass:[SPWorkshopUnit class] json:result];
    
    
    
    //TEST
//    [self handleTag:root];
    
    return units;
}

- (void)handleTag:(TFHpple *)root
{
    TFHppleElement *node = [[root searchWithXPathQuery:@"//div[@class='rightDetailsBlock']"] lastObject];
    
    NSMutableArray *set = [NSMutableArray array];
    
    NSMutableArray *(^arrayInSetForKey)(NSString *) = ^NSMutableArray *(NSString *k){
        if (!k) return nil;
        for (NSDictionary *dict in set) {
            NSString *theK = [[dict allKeys] firstObject];
            if ([k isEqualToString:theK]) {
                return [[dict allValues] firstObject];
            }
        }
        NSDictionary *tmp = @{k:[NSMutableArray array]};
        [set addObject:tmp];
        return [[tmp allValues] firstObject];
    };
    
    NSArray *allChildren = node.children;
    
    NSString *thisClass;
    for (TFHppleElement *element in allChildren) {
        
        NSString *class = [element objectForKey:@"class"];
        if ([class isEqualToString:@"tag_category_desc"]) {
            thisClass = [element text];
            arrayInSetForKey(thisClass);
        }else if([thisClass isEqualToString:@"Heroes"] && [element.tagName isEqualToString:@"div"]){
            NSMutableArray *array = arrayInSetForKey(thisClass);
            for (TFHppleElement *heroNode in [element childrenWithTagName:@"input"]) {
                NSString *id = [heroNode objectForKey:@"id"];
                NSString *value = [heroNode objectForKey:@"value"];
                [array addObject:@[id,value,value]];
            }
        }
        
        if ([class isEqualToString:@"filterOption"] && thisClass) {
            NSMutableArray *array = arrayInSetForKey(thisClass);
            
            TFHppleElement *input = [element firstChildWithTagName:@"input"];
            TFHppleElement *label = [element firstChildWithTagName:@"label"];
            
            NSString *id = [input objectForKey:@"id"];
            NSString *value = [input objectForKey:@"value"];
            NSString *text = [label text];
            
            [array addObject:@{@"id":id,
                               @"value":value,
                               @"text":text}];
        }
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:set options:kNilOptions error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"");
}

- (void)callback:(BOOL)suc isMore:(BOOL)isMore
{
    if (self.updateCallback) {
        self.updateCallback(suc,isMore);
    }
}

- (void)progressCallback:(NSProgress *)p
{
    if (!p) return;
    if (self.progressCallback) {
        int64_t total = p.totalUnitCount;
        int64_t compl = p.completedUnitCount;
        self.progressCallback(compl/(CGFloat)total);
    }
}

#pragma mark - Section
+ (NSString *)sectionVisiblaTitle:(SPWorkshopSection)section
{
    switch (section) {
        case SPWorkshopSectionItem:        return @"物品";      break;
        case SPWorkshopSectionGame:        return @"自定义游戏"; break;
        case SPWorkshopSectionMerchandise: return @"周边产品";   break;
        case SPWorkshopSectionCollections: return @"合集";      break;
    }
}

+ (NSString *)sectionQueryValue:(SPWorkshopSection)section
{
    switch (section) {
        case SPWorkshopSectionItem:        return kSPSectionValueItem;       break;
        case SPWorkshopSectionGame:        return kSPSectionValueGame;       break;
        case SPWorkshopSectionMerchandise: return kSPSectionValueMerchandise;break;
        case SPWorkshopSectionCollections: return kSPSectionValueCollections;break;
    }
}

#pragma mark - Tag
+ (NSMutableArray<NSDictionary<NSString *, NSArray<SPWorkshopTag *> *> *> *)tagsOfSection:(SPWorkshopSection)section
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"workshoptags" ofType:@"json"];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    NSMutableArray *result = json[[@(section) stringValue]];
    
    for (NSMutableDictionary *dict in result) {
        NSMutableArray *tags = [[dict allValues] firstObject];
        NSArray *tagsI = [NSArray yy_modelArrayWithClass:[SPWorkshopTag class] json:tags];
        dict[[[dict allKeys] firstObject]] = tagsI;
    }
    return result;
}

#pragma mark - Detail
+ (void)fetchResource:(SPWorkshopUnit *)unit
           completion:(void(^)(BOOL suc, SPWorkshopUnit *unit))completion
{
    if (!unit || !completion) return;
    
    [[SPSteamAPI shared] fetchWorkshopDetail:unit.id completion:^(BOOL suc, id object, NSString *taskDesc) {
        if (suc){
            TFHpple *root = object;
            TFHppleElement *jsNode = [[root searchWithXPathQuery:@"//div[@id='highlight_player_area']/script"] firstObject];
            
            if ([jsNode hasChildren]) {
                TFHppleElement *js = [jsNode firstChild];
                NSString *jsCode = js.content;

                JSContext *ctx = [[JSContext alloc] init];
                [ctx evaluateScript:jsCode];
                
                JSValue *videoV = [ctx evaluateScript:@"this.rgMovieFlashvars"];
                JSValue *imageV = [ctx evaluateScript:@"this.rgScreenshotURLs"];
//                JSValue *flashV = [ctx evaluateScript:@"this.rgCommonFlashVars"];
                
                NSDictionary *videoObject = [videoV toDictionary];
                NSDictionary *imageObject = [imageV toDictionary];
//                NSDictionary *flashObject = [flashV toDictionary];

                NSMutableArray *resource = [NSMutableArray array];

                // video source
                for (NSString *aVideoK in videoObject) {
                    NSDictionary *aVideoV = videoObject[aVideoK];
                    if ([aVideoV isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *steamVideoID = [[aVideoK componentsSeparatedByString:@"_"] lastObject];
    
                        for (NSString *k in aVideoV) {
                            if ([k isEqualToString:@"YOUTUBE_VIDEO_ID"]) {
                                NSString *youtobeId = aVideoV[k];
                                NSString *youtobeURL = [NSString stringWithFormat:@"https://www.youtube.com/embed/%@?autoplay=1",youtobeId];                                
                                [resource addObject:@{@"id":steamVideoID,
                                                      @"isVideo":@YES,
                                                      @"resource":youtobeURL}];
                                break;
                            }
                        }
                    }
                }
                
                // images
                for (NSString *aImageK in imageObject) {
                    NSString *aImageURL = [[imageObject[aImageK] componentsSeparatedByString:@"?"] firstObject];
                    if (aImageK.length != 0 && aImageURL.length != 0) {
                        [resource addObject:@{@"id":aImageK,
                                              @"isVideo":@NO,
                                              @"resource":aImageURL}];
                    }
                }
                
                NSArray *result = [NSArray yy_modelArrayWithClass:[SPWorkshopResource class] json:resource];
                unit.resources = result;
                completion(YES, unit);
            }else{
                completion(NO,unit);
            }
        }else{
            completion(NO,unit);
        }
    }];
}

@end