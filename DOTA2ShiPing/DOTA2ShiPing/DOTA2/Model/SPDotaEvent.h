//
//  SPDotaEvent.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPDotaEvent : NSObject <NSCoding,NSCopying>
@property (assign, nonatomic) NSInteger id;     //1
@property (copy, nonatomic) NSString *event_id; //EVENT_ID_INTERNATIONAL_2017
@property (copy, nonatomic) NSString *event_name;//DOTA_EventName_International2017
@property (copy, nonatomic) NSString *picture;  //七牛的图片链接
@property (copy, nonatomic) NSString *name_loc; //2017年国际邀请赛
@end
