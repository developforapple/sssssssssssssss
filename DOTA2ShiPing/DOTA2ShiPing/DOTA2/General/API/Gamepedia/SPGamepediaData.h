//
//  SPGamepediaData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPGamepediaImage.h"
#import "SPGamepediaPlayable.h"

@interface SPGamepediaData : SPObject

+ (instancetype)error:(NSError *)error;

@property (strong, nonatomic) NSArray<SPGamepediaImage *> *images;
@property (strong, nonatomic) NSArray<SPGamepediaPlayable *> *playables;
@property (strong, nonatomic) NSError *error;
@end
