//
//  SPItemEntranceConfig.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/7.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif
#import "SPItemCommon.h"

@interface SPItemEntranceUnit : SPObject <NSCopying,NSCoding>
@property (assign, nonatomic) SPItemEntranceType type;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *defaultImage;
@property (copy, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *lastImage;
@end

@interface SPItemEntranceConfig : SPObject

@property (strong, nonatomic) NSArray<SPItemEntranceUnit *> *units;
@property (copy, nonatomic) void (^unitDidUpdated)(SPItemEntranceUnit *unit);

- (SPItemEntranceUnit *)unitOfType:(SPItemEntranceType)type;

- (void)beginUpdateAuto;

@end

