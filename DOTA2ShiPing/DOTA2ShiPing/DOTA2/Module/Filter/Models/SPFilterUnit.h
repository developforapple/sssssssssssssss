//
//  SPFilterUnit.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPFilterDefine.h"

@interface SPFilterUnit : NSObject

@property (assign, nonatomic) SPFilterKind kind;
@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) id object;

@end
