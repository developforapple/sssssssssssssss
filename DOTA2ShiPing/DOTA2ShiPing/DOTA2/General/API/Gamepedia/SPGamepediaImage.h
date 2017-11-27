//
//  SPGamepediaImage.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#if __has_include("SPObject.h")
    #import "SPObject.h"
#else
    #define NSObject SPObject
#endif

NS_ASSUME_NONNULL_BEGIN

//https://dota2.gamepedia.com/media/dota2.gamepedia.com/thumb/a/a4/Aria_of_the_Wild_Wind_Set_prev1.png/120px-Aria_of_the_Wild_Wind_Set_prev1.png?version=1a1700891c7bb2dd332862c6ebd214c5

typedef NS_ENUM(NSUInteger, SPGamepediaImageScale) {
    SPGamepediaImageScale1 = 1,
    SPGamepediaImageScale1x5 = 3,
    SPGamepediaImageScale2 = 4,
    SPGamepediaImageScaleFull = 888,
    SPGamepediaImageScaleBest = 999
};

@interface SPGamepediaImage : SPObject

@property (copy, readonly, nonatomic) NSString *scheme;       //对应 scheme
@property (copy, readonly, nonatomic) NSString *host;         //对应 dota2.gamepedia.com
@property (copy, readonly, nonatomic) NSString *path;         //对应 media/dota2.gamepedia.com
@property (copy, readonly, nonatomic) NSString *filepath;     //对应 a/a4
@property (copy, readonly, nonatomic) NSString *filename;     //对应 Aria_of_the_Wild_Wind_Set_prev1.png
@property (copy, nullable, readonly, nonatomic) NSString *version;      //对应 1a1700891c7bb2dd332862c6ebd214c5

// 基本宽
@property (assign, nonatomic) NSInteger width;
// 基本高
@property (assign, nonatomic) NSInteger height;

+ (nullable instancetype)gamepediaImage:(NSString *)src;

// 完整大小的图片。等同于 thumbImageURL px为0
- (NSURL *)fullsizeImageURL;
- (NSURL *)imageURL:(SPGamepediaImageScale)scale;

@end

NS_ASSUME_NONNULL_END
