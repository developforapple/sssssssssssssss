//
//  SPPlayerItemFilterDefine.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#ifndef SPPlayerItemFilterDefine_h
#define SPPlayerItemFilterDefine_h

typedef NS_OPTIONS(NSUInteger, SPPlayerItemFilterType) {
    SPPlayerItemFilterTypeInput = 1 << 0,
    SPPlayerItemFilterTypeHero = 1 << 1,
    SPPlayerItemFilterTypeQuality = 1 << 2,
    SPPlayerItemFilterTypeRarity = 1 << 3,
    SPPlayerItemFilterTypePrefab = 1 << 4,
    SPPlayerItemFilterTypeSlot = 1 << 5,
    SPPlayerItemFilterTypeTradable = 1 << 6,
    SPPlayerItemFilterTypeMarketable = 1 << 7
};

#define SPPlayerItemFilterTypeAll ( SPPlayerItemFilterTypeInput | \
                                    SPPlayerItemFilterTypeHero | \
                                    SPPlayerItemFilterTypeQuality | \
                                    SPPlayerItemFilterTypeRarity | \
                                    SPPlayerItemFilterTypePrefab | \
                                    SPPlayerItemFilterTypeSlot | \
                                    SPPlayerItemFilterTypeTradable | \
                                    SPPlayerItemFilterTypeMarketable )

#endif /* SPPlayerItemFilterDefine_h */

