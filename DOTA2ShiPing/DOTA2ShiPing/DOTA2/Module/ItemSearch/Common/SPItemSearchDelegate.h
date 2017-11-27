//
//  SPItemSearchDelegate.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@class SPItemSearchViewCtrl;
@class SPItemSearchOption;

@protocol SPItemSearchDelegate <NSObject>

@required
- (NSInteger)numberOfSearchResults:(SPItemSearchViewCtrl *)vc option:(SPItemSearchOption *)option;

@optional
- (void)willDismissSearchController:(SPItemSearchViewCtrl *)vc option:(SPItemSearchOption *)option;

@end
