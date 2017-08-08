//
//  SPItemSets.m
//  ShiPing
//
//  Created by wwwbbat on 16/4/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemSets.h"
#import "YYModel.h"


@interface SPItemSets () <YYModel>

@end

@implementation SPItemSets

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"items"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.items = [dic[@"items"] componentsSeparatedByString:@"||"];
    
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    dic[@"items"] = [self.items componentsJoinedByString:@"||"];
    return YES;
}

YYModelDefaultCode
@end
