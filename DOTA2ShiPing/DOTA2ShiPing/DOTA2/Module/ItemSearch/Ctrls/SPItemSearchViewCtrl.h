//
//  SPItemSearchViewCtrl.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPItemSearchCommon.h"

@protocol SPItemSearchDelegate;

@interface SPItemSearchViewCtrl : YGBaseViewCtrl

@property (weak, readonly, nonatomic) UISearchController *searchCtrl;

+ (SPItemSearchViewCtrl *)showFrom:(UIViewController *)from
                              kind:(SPItemSearchKind)kind
                          delegate:(id<SPItemSearchDelegate>)delegate;
+ (SPItemSearchViewCtrl *)showFrom:(UIViewController *)from
                              kind:(SPItemSearchKind)kind
                          delegate:(id<SPItemSearchDelegate>)delegate
                             setup:(void(^)(UISearchController *))block;


@end
