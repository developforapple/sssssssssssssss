//
//  YGCapabilityHelper.h
//  Golf
//
//  Created by bo wang on 16/8/16.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import Foundation;

@interface YGCapabilityHelper : SPObject

+ (void)call:(NSString *)phoneNumber;
+ (void)call:(NSString *)phoneNumber needConfirm:(BOOL)needConfirm;

@end
