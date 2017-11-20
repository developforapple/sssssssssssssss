//
//  SPFocusVisualEffectVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "YGBaseViewCtrl.h"

UIKIT_EXTERN NSTimeInterval const kSPFocusAnimationDurtaion;

@interface SPFocusVisualEffectVC : YGBaseViewCtrl

- (void)showFocusView:(__weak UIView *)view
           completion:(void(^)(SPFocusVisualEffectVC *focusVC,UIView *focusView))completion;
- (void)dismiss;

@end
