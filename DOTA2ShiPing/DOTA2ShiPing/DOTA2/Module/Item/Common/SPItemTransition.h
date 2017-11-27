//
//  SPItemTransition.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/19.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

@interface SPItemTransition : SPObject <UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

+ (instancetype)transition;

@end
