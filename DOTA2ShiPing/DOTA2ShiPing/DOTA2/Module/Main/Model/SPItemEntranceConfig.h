//
//  SPItemEntranceConfig.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPItemCommon.h"

@interface SPItemEntranceConfig : NSObject

@property (assign, nonatomic) SPItemEntranceType type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;

@end
