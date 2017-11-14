//
//  SPGamepediaPlayable.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SPGamepediaPlayableKind) {
    SPGamepediaPlayableKindAudio = 0, //音频
};

@interface SPGamepediaPlayable : NSObject

@property (assign,readonly, nonatomic) SPGamepediaPlayableKind kind;
@property (copy, readonly, nonatomic) NSString *resource;
@property (copy, readonly, nonatomic) NSString *title;

- (instancetype)initWithURL:(NSString *)URL title:(NSString *)title;

@end
