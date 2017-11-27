//
//  SPPlayerItemSharedData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/24.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPPlayerItems.h"

@class SPPlayerItemFilterUnit;

@interface SPPlayerItemSharedData : SPObject

// GetPlayerItems 接口返回的数据
@property (strong, nonatomic) SPPlayerItemsList *list;

// profile 库存数据
@property (strong, nonatomic) SPPlayerInventory *inventory;

@property (strong, readonly, nonatomic) NSArray<NSNumber *> *tokens;

@property (strong, readonly, nonatomic) NSArray<SPPlayerItemFilterUnit *> *qualityTags;
@property (strong, readonly, nonatomic) NSArray<SPPlayerItemFilterUnit *> *rarityTags;
@property (strong, readonly, nonatomic) NSArray<SPPlayerItemFilterUnit *> *prefabTags;
@property (strong, readonly, nonatomic) NSArray<SPPlayerItemFilterUnit *> *slotTags;
@property (strong, readonly, nonatomic) NSArray<SPPlayerItemFilterUnit *> *heroTags;

@end

