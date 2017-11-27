//
//  YGThirdPartyNavigate.h
//  CDT
//
//  Created by wwwbbat on 2017/7/3.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

typedef NS_ENUM(NSUInteger, YGNavigateKind) {
    YGNavigateKindGaode,
    YGNavigateKindBaidu,
    YGNavigateKindApple,
};

@interface YGThirdPartyNavigate : SPObject

// 传入GCJ坐标系
+ (void)navigateTo:(CLLocationCoordinate2D)coordinate name:(NSString *)name view:(UIView *)view;
+ (void)navigateTo:(CLLocationCoordinate2D)coordinate name:(NSString *)name use:(YGNavigateKind)kind;

@end
