//
//  SPFilterUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPFilterDefine.h"

@interface SPFilterUnit : SPObject

@property (assign, nonatomic) SPFilterKind kind;
@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) id object;

@end
