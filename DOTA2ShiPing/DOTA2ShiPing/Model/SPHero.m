//
//  SPHero.m
//  ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPHero.h"
#import "SPItemSlot.h"
#import "YYModel.h"

@interface SPHero() <YYModel>

@end

@implementation SPHero

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"slot":[SPItemSlot class]};
}

@end