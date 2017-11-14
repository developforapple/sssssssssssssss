//
//  SPGamepediaData.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPGamepediaImage.h"
#import "SPGamepediaPlayable.h"

@interface SPGamepediaData : NSObject

@property (strong, nonatomic) NSArray<SPGamepediaImage *> *images;
@property (strong, nonatomic) NSArray<SPGamepediaPlayable *> *playables;

@end
