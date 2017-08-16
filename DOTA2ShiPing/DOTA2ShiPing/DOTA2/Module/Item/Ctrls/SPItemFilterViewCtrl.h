//
//  SPItemFilterViewCtrl.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"
#import "YGBaseNaviCtrl.h"
#import "SPFilterOption.h"

typedef void(^SPItemFilterCompletion)(BOOL canceled,NSArray<SPFilterOption *> *options);

@interface SPItemFilterNaviCtrl : YGBaseNaviCtrl
- (void)setup:(SPFilterOptionType)types
      options:(NSArray *)options
   completion:(SPItemFilterCompletion)completion;
@end

@interface SPItemFilterViewCtrl : YGBaseViewCtrl
@end
