//
//  SPPlayerItemFilter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/26.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBaseFilter.h"
#import "SPPlayerItemFilterDefine.h"
#import "SPPlayerItemSharedData.h"

@interface SPPlayerItemFilter : SPBaseFilter

@property (assign, readonly, nonatomic) SPPlayerItemFilterType types;

- (void)setupTypes:(SPPlayerItemFilterType)types
        sharedData:(SPPlayerItemSharedData *)sharedData;

@end
