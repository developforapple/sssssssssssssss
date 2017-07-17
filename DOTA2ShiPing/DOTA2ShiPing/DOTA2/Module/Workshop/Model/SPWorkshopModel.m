//
//  SPWorkshopModel.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopModel.h"
#import "SPWorkshop.h"
#import "SPHero.h"
#import <YYModel.h>
#import "IDMPhoto.h"

@implementation SPWorkshopQuery

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetPage];
    }
    return self;
}

- (void)resetPage
{
    self.pageSize = kSPMiddlePageSize;
    self.pageNo = kSPDefaultPageNo;
}

- (void)setIsAccept:(BOOL)isAccept
{
    _isAccept = isAccept;
    self.sort = nil;
    [self resetPage];
}

- (void)setSection:(SPWorkshopSection)section
{
    _section = section;
    [self resetPage];
}

- (void)setSort:(SPWorkshopSort *)sort
{
    _sort = sort;
    [self resetPage];
}

- (NSMutableDictionary *)baseQuery
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[kSPQueryKeySection] = [SPWorkshop sectionQueryValue:self.section];
    
    if (self.isAccept) {
        query[kSPQueryKeyBrowsesort] = @"accepted";
    }else if (self.sort){
        query[kSPQueryKeyBrowsesort] = self.sort.actualsort;
        query[kSPQueryKeyActualsort] = self.sort.actualsort;
        query[kSPQueryKeyDays] = self.sort.days;
    }
    
    if (self.requiredtags.count != 0) {
        for (SPWorkshopTag *tag in self.requiredtags) {
            NSString *k = [NSString stringWithFormat:@"requiredtags[%lu]",[self.requiredtags indexOfObject:tag]];
            NSString *v = tag.value;
            query[k] = v;
        }
    }
    return query;
}

- (NSDictionary *)query
{
    NSMutableDictionary *query = [self baseQuery];
    query[kSPQueryKeyPageNo] = @(self.pageNo);
    query[kSPQueryKeyNumperpage] = @(self.pageSize);
    return query;
}

- (NSString *)cacheKey
{
    NSMutableDictionary *query = [self baseQuery];
    NSData *data = [NSJSONSerialization dataWithJSONObject:query options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

YYModelDefaultCode
@end

#pragma mark - Tag
@implementation SPWorkshopTag

+ (instancetype)tagOfHero:(SPHero *)hero
{
    if (!hero || !hero.name) return nil;
    
    static NSArray *heroMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"heroMap" ofType:@"json"];
        heroMap = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
    });
    SPWorkshopTag *tag;
    for (NSArray *aHero in heroMap) {
        NSString *text = aHero[2];
        if ([text isEqualToString:hero.name]) {
            tag = [SPWorkshopTag new];
            tag.id = aHero[0];
            tag.value = aHero[1];
            tag.text = hero.name_loc;
            break;
        }
    }
    if (!tag) {
        tag = [SPWorkshopTag new];
        tag.value = hero.name;
        tag.text = hero.name_loc;
    }
    return tag;
}

+ (instancetype)tagOfSlot:(SPItemSlot *)slot
{
    if (!slot || !slot.SlotName) return nil;
    
    SPWorkshopTag *tag = [SPWorkshopTag new];
    tag.id = @"";
    tag.value = slot.SlotName;
    tag.text = slot.name_loc?:slot.SlotName;
    return tag;
}

+ (NSArray<SPWorkshopTag *> *)tagsOfHeroSlots:(SPHero *)hero
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (SPItemSlot *slot in hero.ItemSlots) {
        SPWorkshopTag *tag = [self tagOfSlot:slot];
        if (tag) {
            [tmp addObject:tag];
        }
    }
    return tmp;
}

YYModelDefaultCode
@end

#pragma mark - Sort
@implementation SPWorkshopSort

- (instancetype)initWithName:(NSString *)name sort:(NSString *)sort day:(NSUInteger)day isDefault:(BOOL)isDefault
{
    self = [super init];
    if (self) {
        self.name = name;
        self.actualsort = sort;
        self.days = day<1?nil:@(day);
        self.isDefault = isDefault;
    }
    return self;
}

+ (NSArray<SPWorkshopSort *> *)sortForSection:(SPWorkshopSection)section
{
    SPWorkshopSort *(^Create)(NSString *,NSString *,NSUInteger,BOOL) =
    ^SPWorkshopSort *(NSString *name,NSString *sort,NSUInteger day,BOOL isDefault){
        return [[SPWorkshopSort alloc] initWithName:name sort:sort day:day isDefault:isDefault];
    };
    
    switch (section) {
        case SPWorkshopSectionItem: {
            return @[Create(@"最热门（今天）",  @"trend",       1,  YES),
                     Create(@"最新",          @"mostrecent",  0,  NO)];
            break;
        }
        case SPWorkshopSectionGame: {
            return @[Create(@"最热门（今天）",      @"trend",          1,NO),
                     Create(@"最热门（一周）",      @"trend",          7,YES),
                     Create(@"最热门（三个月）",    @"trend",           90,NO),
                     Create(@"最热门（半年）",      @"trend",          180,NO),
                     Create(@"最热门（一年）",      @"trend",          365,NO),
                     Create(@"评分最高（发布至今）", @"toprated",         0,NO),
                     Create(@"最新",              @"mostrecent",       0,NO),
                     Create(@"最多订阅",           @"totaluniquesubscribers",0,NO)];
            break;
        }
        case SPWorkshopSectionMerchandise: {
            return @[Create(@"最热门（今天）",      @"trend",          1,NO),
                     Create(@"最热门（一周）",      @"trend",          7,YES),
                     Create(@"最热门（三个月）",    @"trend",           90,NO),
                     Create(@"最热门（半年）",      @"trend",          180,NO),
                     Create(@"最热门（一年）",      @"trend",          365,NO),
                     Create(@"评分最高（发布至今）", @"toprated",         0,NO),
                     Create(@"最新",              @"mostrecent",       0,NO)];
            break;
        }
        case SPWorkshopSectionCollections: {
            return @[Create(@"最热门（今天）",      @"trend",          1,NO),
                     Create(@"最热门（一周）",      @"trend",          7,YES),
                     Create(@"最热门（三个月）",    @"trend",           90,NO),
                     Create(@"最热门（半年）",      @"trend",          180,NO),
                     Create(@"最热门（一年）",      @"trend",          365,NO),
                     Create(@"评分最高（发布至今）", @"toprated",         0,NO),
                     Create(@"最新",              @"mostrecent",       0,NO)];
            break;
        }
    }
}

+ (NSArray<NSString *> *)titlesOfSorts:(NSArray<SPWorkshopSort *> *)sorts
{
    return [sorts mutableArrayValueForKeyPath:@"name"];
}

YYModelDefaultCode
@end

#pragma mark - Unit
@interface SPWorkshopUnit ()<YYModel>
{
    NSMutableDictionary *_sizeCahce;
}
@end
@implementation SPWorkshopUnit

- (NSURL *)detailURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://steamcommunity.com/sharedfiles/filedetails/?id=%@",self.id]];
}

- (NSURL *)imageURLForSize:(CGSize)size
{
    if (!_sizeCahce) {
        _sizeCahce = [NSMutableDictionary dictionary];
    }
    NSValue *k = [NSValue valueWithCGSize:size];
    NSURL *URL = _sizeCahce[k];
    if (!URL) {
        NSURLComponents *components = [NSURLComponents componentsWithString:[self.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *fitValue = [NSString stringWithFormat:@"inside|%d:%d",(int)size.width,(int)size.height];
        NSString *compositetValue = [NSString stringWithFormat:@"*,*|%d:%d",(int)size.width,(int)size.height];
        
        NSArray *items = [components queryItems];
        for (NSURLQueryItem *item in items) {
            if ([item.name isEqualToString:@"fit"]) {
                [item setValue:fitValue forKey:@"value"];
            }else if([item.name isEqualToString:@"composite-to"]){
                [item setValue:compositetValue forKey:@"value"];
            }else if ([item.name isEqualToString:@"output-quality"]){
                [item setValue:@"85" forKey:@"value"];
            }
        }
        [components setQueryItems:items];
        URL = [components URL];
        _sizeCahce[k] = URL;
    }
    return URL;
}

- (NSArray<IDMPhoto *> *)imageResourceIDMPhotos
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (SPWorkshopResource *resource in self.resources) {
        if (![resource isVideo]) {
            [tmp addObject:resource.photo];
        }
    }
    return tmp;
}

- (NSUInteger)indexInImageResourcesOfResource:(SPWorkshopResource *)resource
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (SPWorkshopResource *resource in self.resources) {
        if (![resource isVideo]) {
            [tmp addObject:resource];
        }
    }
    return [tmp indexOfObject:resource];
}

YYModelDefaultCode
@end

#pragma mark - Resource Mode
@implementation SPWorkshopResource

- (IDMPhoto *)photo
{
    if (!_photo) {
        _photo = [IDMPhoto photoWithURL:[self fullURL]];
    }
    _photo.placeholderImage = [[YYWebImageManager sharedManager].cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[self thumbURL]]];
    return _photo;
}

- (BOOL)isGif
{
    if ([self.resource hasPrefix:@"http://cloud-"] || [self.resource hasPrefix:@"https://cloud-"]) {
        return YES;
    }
    return NO;
}

- (NSURL *)createURLWith:(NSUInteger)quality
               imageSize:(CGSize)imageSize
              canvasSize:(CGSize)canvasSize
               backColor:(NSString *)colorName
{
    NSURLComponents *components = [NSURLComponents componentsWithString:[self.resource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.isVideo) {
        return components.URL;
    }
    
    NSURLQueryItem *item1 = [NSURLQueryItem queryItemWithName:@"interpolation" value:@"lanczos-none"];
    NSURLQueryItem *item2 = [NSURLQueryItem queryItemWithName:@"output-format" value:@"webP"];
    if (quality == 0) {
        components.queryItems = @[item1,item2];
        NSURL *URL = components.URL;
        return URL;
    }
    
    NSURLQueryItem *item3 = [NSURLQueryItem queryItemWithName:@"output-quality" value:[@(quality) stringValue]];
    NSMutableArray *items = [NSMutableArray arrayWithObjects:item1,item2,item3, nil];
    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
        NSString *v = [NSString stringWithFormat:@"inside|%ld:%ld",(long)imageSize.width,(long)imageSize.height];
        NSURLQueryItem *item4 = [NSURLQueryItem queryItemWithName:@"fit" value:v];
        [items addObject:item4];
    }
    if (!CGSizeEqualToSize(canvasSize, CGSizeZero)) {
        NSString *v = [NSString stringWithFormat:@"*,*|%ld:%ld",(long)canvasSize.width,(long)canvasSize.height];
        NSURLQueryItem *item5 = [NSURLQueryItem queryItemWithName:@"composite-to" value:v];
        [items addObject:item5];
    }
    if (colorName.length != 0) {
        NSURLQueryItem *item6 = [NSURLQueryItem queryItemWithName:@"background-color" value:colorName];
        [items addObject:item6];
    }
    
    components.queryItems = items;
    NSURL *URL = [components URL];
    return URL;
}

- (NSURL *)testURL
{
    return [self createURLWith:1 imageSize:CGSizeZero canvasSize:CGSizeZero backColor:nil];
}

- (NSURL *)thumbURL
{
    CGSize size = CGSizeMake(Device_Width*2, Device_Width*2*0.618f);
    return [self createURLWith:75 imageSize:size canvasSize:size backColor:@"black"];
}

- (NSURL *)fullURL
{
    return [self createURLWith:0 imageSize:CGSizeZero canvasSize:CGSizeZero backColor:nil];
}

+ (NSString *)cacheKeyOfURL:(NSURL *)URL
{
    NSString *MD5 = URL.lastPathComponent;
    NSString *query = URL.query;
    NSString *k = [NSString stringWithFormat:@"%@/?%@",MD5,query];
    return k;
}

YYModelDefaultCode
@end

#pragma mark - Constant
// section
NSString *const kSPQueryKeySection = @"section";
NSString *const kSPSectionValueItem = @"mtxitems";
NSString *const kSPSectionValueGame = @"readytouseitems";
NSString *const kSPSectionValueMerchandise = @"merchandise";
NSString *const kSPSectionValueCollections = @"collections";

// page
NSString *const kSPQueryKeyNumperpage = @"numperpage";//value 默认18
NSString *const kSPQueryKeyPageNo = @"p";             //value 默认1
NSInteger const kSPMinimumPageSize = 9;
NSInteger const kSPMiddlePageSize  = 18;
NSInteger const kSPMaximumPageSize = 30;
NSInteger const kSPDefaultPageNo = 1;

// sort
NSString *const kSPQueryKeyBrowsesort = @"browsesort";
NSString *const kSPQueryKeyActualsort = @"actualsort";
NSString *const kSPQueryKeyDays = @"days";


