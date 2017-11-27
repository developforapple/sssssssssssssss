//
//  SPGamepediaPlayable.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

typedef NS_ENUM(NSUInteger, SPGamepediaPlayableKind) {
    SPGamepediaPlayableKindAudio = 0, //音频
};

@interface SPGamepediaPlayable : SPObject

@property (assign,readonly, nonatomic) SPGamepediaPlayableKind kind;
@property (copy, readonly, nonatomic) NSString *resource;
@property (copy, readonly, nonatomic) NSString *title;

- (instancetype)initWithURL:(NSString *)URL title:(NSString *)title;

@end
