//
//  YGThirdPartyNavigate.h
//  CDT
//
//  Created by wwwbbat on 2017/7/3.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YGNavigateKind) {
    YGNavigateKindGaode,
    YGNavigateKindBaidu,
    YGNavigateKindApple,
};

@interface YGThirdPartyNavigate : NSObject

// 传入GCJ坐标系
+ (void)navigateTo:(CLLocationCoordinate2D)coordinate name:(NSString *)name view:(UIView *)view;
+ (void)navigateTo:(CLLocationCoordinate2D)coordinate name:(NSString *)name use:(YGNavigateKind)kind;

@end
