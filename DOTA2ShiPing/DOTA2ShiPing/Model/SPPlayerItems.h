//
//  SPPlayerInventory.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/6/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@class SPPlayerItemDetail;
@class SPPlayerItem;
@class SPPlayerInvertoryItemTag;
@class SPPlayerInventoryItemDesc;

#pragma mark - 用户的库存清单

// 用户饰品清单时的数据状态
typedef NS_ENUM(NSUInteger, SPPlayerItemsListStatus) {
    SPPlayerItemsListStatusFailure = 0,     //请求失败
    SPPlayerItemsListStatusSuccess = 1,     //成功
    SPPlayerItemsListStatusInvalid = 8,     //steamid无效
    SPPlayerItemsListStatusPrivate = 15,    //库存私有
    SPPlayerItemsListStatusNotExist = 18,   //steamid不存在
};

// GetPlayerItems/v0001/ 获取的饰品数据
@interface SPPlayerItemsList : NSObject <NSCopying,NSCoding,YYModel>
@property (assign, nonatomic) SPPlayerItemsListStatus status;
@property (strong, nonatomic) NSArray<SPPlayerItem *> *items;

@property (strong, nonatomic) NSNumber *eigenvalue NS_DEPRECATED_IOS(7_0,8_0, "asdfasdfasdf");
@property (strong, nonatomic) NSString *MD5;

// 根据id查找defindex。不用考虑效率
- (NSNumber *)defindexOfItemID:(NSNumber *)itemid;

@end

@interface SPPlayerItem : NSObject <NSCopying,NSCoding,YYModel>
@property (strong, nonatomic) NSNumber *id;         //id
@property (strong, nonatomic) NSNumber *defindex;   //索引
@end

#pragma mark - 用户的库存详情
// 库存数据
@interface SPPlayerInventory : NSObject <NSCopying,NSCoding,YYModel>

+ (NSIndexSet *)startIndexesOfItemsCount:(NSUInteger)count;

// 合并多个库存
+ (instancetype)merge:(NSArray<SPPlayerInventory *> *)inventories;

@property (strong, nonatomic) NSNumber *success;
@property (strong, nonatomic) NSArray<SPPlayerItemDetail *> *items;
@property (strong, nonatomic) NSNumber *more_start;
@property (strong, nonatomic) NSNumber *more;

// 为 items 中的每个饰品生成 defindex。 defindex来自于 list
- (void)infuseItemList:(SPPlayerItemsList *)list;

@end

@interface SPPlayerItemDetail : NSObject <NSCopying, NSCoding, YYModel>

// 来自rgInventory
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *classid;
@property (strong, nonatomic) NSNumber *instanceid;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSNumber *pos;

// 来自rgDescriptions
@property (strong, nonatomic) NSString *icon_url;
@property (strong, nonatomic) NSString *icon_url_large;
@property (strong, nonatomic) NSString *icon_drag_url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *market_hash_name;
@property (strong, nonatomic) NSString *market_name;
@property (strong, nonatomic) NSString *name_color;
@property (strong, nonatomic) NSString *background_color;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *tradable;
@property (strong, nonatomic) NSNumber *marketable;
@property (strong, nonatomic) NSNumber *commodity;
@property (strong, nonatomic) NSString *market_tradable_restriction;
@property (strong, nonatomic) NSString *market_marketable_restriction;
@property (strong, nonatomic) NSArray<SPPlayerInventoryItemDesc *> *descriptions;
@property (strong, nonatomic) NSArray<SPPlayerInvertoryItemTag *> *tags;
@property (strong, nonatomic) NSString *cache_expiration;
@property (strong, nonatomic) NSArray<NSString *> *fraudwarnings;

// 来自 SPPlayerItemsList 需要额外赋值
@property (strong, nonatomic) NSNumber *defindex;

- (SPPlayerInvertoryItemTag *)rarityTag;
- (SPPlayerInvertoryItemTag *)heroTag;
- (SPPlayerInvertoryItemTag *)typeTag;
- (SPPlayerInvertoryItemTag *)qualityTag;
- (SPPlayerInvertoryItemTag *)slotTag;

@end

// rgDescriptions 内的描述列表
@interface SPPlayerInventoryItemDesc : NSObject <NSCopying,NSCoding,YYModel>
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSDictionary *app_data;
@end

#import "SPItemColor.h"

// rgDescriptions 内的标签列表
@interface SPPlayerInvertoryItemTag : NSObject <NSCopying,NSCoding,YYModel>
@property (strong, nonatomic) NSString *internal_name;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *category_name;

// 不需要归档
@property (strong, nonatomic) SPItemColor *tagColor;

@end
