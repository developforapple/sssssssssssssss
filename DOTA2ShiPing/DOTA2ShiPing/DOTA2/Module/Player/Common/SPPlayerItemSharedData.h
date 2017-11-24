//
//  SPPlayerItemSharedData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/24.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlayerItems.h"

@interface SPPlayerItemSharedData : NSObject

// GetPlayerItems 接口返回的数据
@property (strong, nonatomic) SPPlayerItemsList *list;

// profile 库存数据
@property (strong, nonatomic) SPPlayerInventory *inventory;

@property (strong, readonly, nonatomic) NSArray<NSNumber *> *tokens;

@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *qualityTags;
@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *rarityTags;
@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *prefabTags;
@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *slotTags;
@property (strong, readonly, nonatomic) NSDictionary<NSString *,NSString *> *heroTags;

@end
