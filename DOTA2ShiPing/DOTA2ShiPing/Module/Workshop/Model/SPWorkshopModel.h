//
//  SPWorkshopModel.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/16.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@class SPWorkshopQuery;
@class SPWorkshopUnit;
@class SPWorkshopTag;
@class SPWorkshopSort;
@class SPHero;
@class SPItemSlot;
@class SPWorkshopResource;
@class IDMPhoto;

typedef NS_ENUM(NSUInteger, SPWorkshopSection) {
    SPWorkshopSectionItem,
    SPWorkshopSectionGame,
    SPWorkshopSectionMerchandise,
    SPWorkshopSectionCollections,
};

#pragma mark - Query Model
@interface SPWorkshopQuery : NSObject <NSCopying,NSCoding>
// query
@property (assign, nonatomic) SPWorkshopSection section;
@property (strong, nullable, nonatomic) NSArray<SPWorkshopTag *> *requiredtags;
@property (strong, nullable, nonatomic) SPWorkshopSort *sort;
@property (assign, nonatomic) NSUInteger pageSize;  //每页数量 默认9
@property (assign, nonatomic) NSUInteger pageNo;    //当前页码 默认1
@property (assign, nonatomic) BOOL isAccept;        //是否是已采纳的内容。设为YES时将清空sort

// 拿来做网络请求的参数
- (NSDictionary *)query;
// 拿来做缓存的key
- (NSString *)cacheKey;
@end

#pragma mark - Tag Model
@interface SPWorkshopTag : NSObject <NSCopying,NSCoding>
@property (strong, nonatomic) NSString *id;    //查询时的tag
@property (strong, nonatomic) NSString *value;   //显示的名字
@property (strong, nonatomic) NSString *text;

// 一个英雄对应的tag
+ (instancetype)tagOfHero:(SPHero *)hero;
// 一个部位对应的tag
+ (instancetype)tagOfSlot:(SPItemSlot *)slot;
// 一个英雄的所有部位的tag
+ (NSArray<SPWorkshopTag *> *)tagsOfHeroSlots:(SPHero *)hero;

@end

#pragma mark - Sort Model

@interface SPWorkshopSort : NSObject <NSCopying,NSCoding>
@property (strong, nonatomic) NSString *name;           //显示的标题
@property (strong, nonatomic) NSString *actualsort;     //不是已采纳的情况下也是browsesort字段的值
@property (strong, nullable,nonatomic) NSNumber *days;  //为空时忽略该字段
@property (assign, nonatomic) BOOL isDefault;           //是否是默认选项。

+ (NSArray<SPWorkshopSort *> *)sortForSection:(SPWorkshopSection)section;
+ (NSArray<NSString *> *)titlesOfSorts:(NSArray<SPWorkshopSort *> *)sorts;

@end

#pragma mark - Unit Model
@interface SPWorkshopUnit : NSObject <NSCopying,NSCoding>
@property (strong, nonatomic) NSNumber *id;         //id
@property (strong, nonatomic) NSString *imageURL;   //图片url
@property (strong, nonatomic) NSString *title;      //标题
@property (strong, nonatomic) NSString *desc;       //描述
@property (strong, nonatomic) NSArray<NSString *>*authors;     //作者们

@property (strong, nonatomic) NSArray<SPWorkshopResource *> *resources; //资源

- (NSURL *)detailURL;
- (NSURL *)imageURLForSize:(CGSize)size;

- (NSArray<IDMPhoto *> *)imageResourceIDMPhotos;

// 图片资源在所有资源中的图片资源的index
- (NSUInteger)indexInImageResourcesOfResource:(SPWorkshopResource *)resource;

@end

#pragma mark - Resource Model
/**
 *  创意工坊物品的视频和图片资源。
 */
@interface SPWorkshopResource : NSObject <NSCopying, NSCoding>
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) IDMPhoto *photo;

/**
 *  是否是视频。在创建时即可确定。
 */
@property (assign, nonatomic) BOOL isVideo;

/**
 *  从详情页得到的原始链接。根据需要可以创建不同的图片链接。
 */
@property (strong, nonatomic) NSString *resource;

/**
 *  是否是GIF图片。根据图片链接判断。images.akamai.steamusercontent.com 为普通图片 cloud-1231456.steamusercontent.com为GIF图片
 */
@property (assign, nonatomic) BOOL isGif;

/**
 *  创建资源图片URL。如果是视频，返回视频连接。如果是GIF，返回原始链接。如果还不知道是不是gif，根据规则返回webP格式的图片链接。
 *
 *  @param quality    图片质量。为0时为全尺寸的大图。
 *  @param imageSize  图片尺寸。指内部显示的内容尺寸。
 *  @param canvasSize 画布尺寸。指整个图片的尺寸。
 *  @param colorName  背景颜色。当画布尺寸大于图片尺寸时，画布的其余部分显示的颜色。
 *  @warning canvasSize 需要不小于imageSize 或者为Zero 否则图片会显示不完整
 *
 *  @return URL
 */
- (NSURL *)createURLWith:(NSUInteger)quality
               imageSize:(CGSize)imageSize
              canvasSize:(CGSize)canvasSize
               backColor:(nullable NSString *)colorName;

/**
 *  测试图片的链接。图片质量为1，尺寸为原始尺寸。图片格式为webP
 *  用于确定链接的真实尺寸。如果是GIF判断真实尺寸代价太大因此建议用一个固定尺寸。
 *
 *  @return URL
 */
- (NSURL *)testURL;

/**
 *  缩略图链接。返回设备宽的正方形图片。空白区域填充黑色。图片格式为webP
 *
 *  @return URL
 */
- (NSURL *)thumbURL;
/**
 *  原始链接。图片质量为95。尺寸为原始尺寸。图片格式为webP
 *
 *  @return URL
 */
- (NSURL *)fullURL;

/*!
 *  @brief URL对应的图片key
 *
 *  @param URL URL
 *
 *  @return key
 */
+ (NSString *)cacheKeyOfURL:(NSURL *)URL;

@end

#pragma mark - Constant
// Section
FOUNDATION_EXTERN NSString *const kSPQueryKeySection;   //key:   创意工坊内容分类
FOUNDATION_EXTERN NSString *const kSPSectionValueItem;  //value: 物品
FOUNDATION_EXTERN NSString *const kSPSectionValueGame;  //value: 自定义游戏
FOUNDATION_EXTERN NSString *const kSPSectionValueMerchandise;//value:周边商品
FOUNDATION_EXTERN NSString *const kSPSectionValueCollections;//value:合集

// Page
FOUNDATION_EXTERN NSString *const kSPQueryKeyNumperpage;    //每页内容的数量
FOUNDATION_EXTERN NSString *const kSPQueryKeyPageNo;        //当前页码
FOUNDATION_EXTERN NSInteger const kSPMinimumPageSize;       //最小数量 9
FOUNDATION_EXTERN NSInteger const kSPMiddlePageSize;        //中等数量 18
FOUNDATION_EXTERN NSInteger const kSPMaximumPageSize;       //最大数量 30
FOUNDATION_EXTERN NSInteger const kSPDefaultPageNo;         //默认页码 1

// sort
FOUNDATION_EXTERN NSString *const kSPQueryKeyBrowsesort;    //不是已采纳时，和Actualsort一样。
FOUNDATION_EXTERN NSString *const kSPQueryKeyActualsort;    //排序方式
FOUNDATION_EXTERN NSString *const kSPQueryKeyDays;          //days

NS_ASSUME_NONNULL_END