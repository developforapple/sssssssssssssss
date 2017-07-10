//
//  DDBasePopViewController.h
//  QuizUp
//
//  Created by Normal on 11/12/15.
//  Copyright © 2015 Bo Wang. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@interface YGBasePopViewCtrl : YGBaseViewCtrl

@property (copy, nonatomic) void (^didDisplayed)(YGBasePopViewCtrl *);
@property (copy, nonatomic) void (^didDismissed)(YGBasePopViewCtrl *);

- (void)show;
- (void)show:(void(^)(void))code;
- (void)showInLowWindowLevel;
- (void)showHightLevel;
- (void)dismiss;
- (void)dismiss:(void (^)(void))completion;
- (void)didShowAnimation;

- (void)show:(NSTimeInterval)duration animations:(void(^)(void))animations completed:(void(^)(void))completed;

- (void)showWithoutAnimation;

@end
