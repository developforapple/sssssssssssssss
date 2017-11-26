//
//  SPItemFilter.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPBaseFilter.h"
#import "SPItemFilterDefine.h"
#import "SPItemFilterDelegate.h"

@interface SPItemFilter : SPBaseFilter

- (id<SPItemFilterDelegate>)delegate;

@property (assign, readonly, nonatomic) SPItemFilterType types;

- (void)setupTypes:(SPItemFilterType)types;

@end
