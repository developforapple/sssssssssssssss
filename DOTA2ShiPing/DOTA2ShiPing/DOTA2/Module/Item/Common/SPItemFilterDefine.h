//
//  SPItemFilterDefine.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#ifndef SPItemFilterDefine_h
#define SPItemFilterDefine_h

typedef NS_OPTIONS(NSInteger, SPItemFilterType) {
    SPItemFilterTypeInput = 1 << 0,
    SPItemFilterTypeHero = 1 << 1,
    SPItemFilterTypeRarity = 1 << 2,
    SPItemFilterTypeEvent = 1 << 3
};

#define SPItemFilterTypeAll (   SPItemFilterTypeInput | \
                                SPItemFilterTypeHero | \
                                SPItemFilterTypeRarity | \
                                SPItemFilterTypeEvent )

#endif /* SPItemFilterDefine_h */
