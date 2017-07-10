//
//  UIView+Animation.h
//  Golf
//
//  Created by bo wang on 16/6/28.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import UIKit;

@interface UIView (Animation)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setHidden:(BOOL)hidden
         animated:(BOOL)animated
       completion:(void(^)(void))completion;

@end
