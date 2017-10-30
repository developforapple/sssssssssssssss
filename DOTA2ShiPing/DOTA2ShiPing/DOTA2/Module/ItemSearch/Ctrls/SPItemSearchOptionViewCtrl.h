//
//  SPItemSearchOptionViewCtrl.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "SPItemSearchOption.h"
#import "SPItemSearchDelegate.h"

@interface SPItemSearchOptionViewCtrl : YGBaseViewCtrl

@property (weak, nonatomic) id<SPItemSearchDelegate> delegate;
@property (strong, nonatomic) SPItemSearchOption *option;

- (void)updateKeywords:(NSString *)keywords;

@end
