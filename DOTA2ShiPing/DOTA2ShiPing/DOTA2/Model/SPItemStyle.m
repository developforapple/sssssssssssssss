//
//  SPItemStyle.m
//  ShiPing
//
//  Created by wwwbbat on 2017/7/21.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemStyle.h"
#import "YYModel.h"

@implementation SPItemStyle

YYModelDefaultCode

+ (instancetype)styleOfInfo:(NSDictionary *)info index:(NSString *)index
{
    SPItemStyle *style = [SPItemStyle new];
    style.index = index;
    style.name = info[@"name"];
    
    NSDictionary *unlockDict = info[@"child"][@"unlock"];
    
    if (unlockDict) {
//        NSLog(@"%@",unlockDict.allKeys);
        
        SPItemStyleUnlock *unlockObj = [SPItemStyleUnlock new];
        
        NSDictionary *childInfo = unlockDict[@"child"];
//        NSLog(@"%@",childInfo.allKeys);
        
        NSDictionary *gemInfo = childInfo[@"gem"];
        if (gemInfo) {
            unlockObj.type_field = gemInfo[@"type_field"];
            unlockObj.def_index = gemInfo[@"def_index"];
            unlockObj.unlock_field = gemInfo[@"unlock_field"];
            unlockObj.unlock_value = gemInfo[@"unlock_value"];
            unlockObj.type_value = gemInfo[@"type_value"];
        }else{
            unlockObj.item_def = unlockDict[@"item_def"];
        }
        
        style.unlock = unlockObj;
    }
    return style;
}

@end

@implementation SPItemStyleUnlock
YYModelDefaultCode
@end
