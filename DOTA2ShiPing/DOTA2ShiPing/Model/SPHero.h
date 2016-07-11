//
//  SPHero.h
//  ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPItemCommon.h"
#import "SPItemSlot.h"

@interface SPHero : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *name_cn;

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSNumber *position;
@property (assign, nonatomic) SPHeroType type;
@property (assign, nonatomic) SPHeroCamp subType;

@property (strong, nonatomic) NSArray<SPItemSlot *> *slot;

@end
