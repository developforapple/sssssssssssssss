//
//  SPGamepediaPlayable.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/11/14.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaPlayable.h"

@interface SPGamepediaPlayable ()
@property (assign, readwrite, nonatomic) SPGamepediaPlayableKind kind;
@property (copy, readwrite, nonatomic) NSString *resource;
@property (copy, readwrite, nonatomic) NSString *title;
@end

@implementation SPGamepediaPlayable

- (instancetype)initWithURL:(NSString *)URL title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.resource = URL;
        self.title = title;
        self.kind = SPGamepediaPlayableKindAudio;
    }
    return self;
}

@end
