//
//  YGThirdPlatformProcessor.h
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import Foundation;

@interface YGThirdPlatformProcessor : SPObject

+ (instancetype)processor;

+ (BOOL)canHandleURL:(NSURL *)URL;

- (BOOL)handleURL:(NSURL *)URL;

@end
