//
//  TQLocationConverter.h
//  
//
//  Created by qfu on 9/16/14.
//  Copyright (c) 2014 tinyq. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface TQLocationConverter : NSObject

/**
 *  判断是否在中国
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 *  将WGS-84转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

/**
 *  将GCJ-02(火星坐标)转为百度坐标:
 */
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;

/**
 *  将百度坐标转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;

/**
 *  将GCJ-02(火星坐标)转为WGS-84:
 */
+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;

/**
 计算两WGS经纬度坐标的距离

 @param coordinate1 坐标1
 @param coordinate2 坐标2
 @return 距离，单位米
 */
+ (float)distanceBetween:(CLLocationCoordinate2D)coordinate1 and:(CLLocationCoordinate2D)coordinate2;

@end

// 同 distanceBetween:and:
extern double get_distance(double lat1, double lng1, double lat2, double lng2);
