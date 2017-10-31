//
//  SPGamepediaImage.h
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//https://dota2.gamepedia.com/media/dota2.gamepedia.com/thumb/a/a4/Aria_of_the_Wild_Wind_Set_prev1.png/120px-Aria_of_the_Wild_Wind_Set_prev1.png?version=1a1700891c7bb2dd332862c6ebd214c5

@interface SPGamepediaImage : NSObject

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

// px只能是 0 或者 width的 1倍、1.5倍、2倍。px为0时等同于 fullsizeImageURL
- (NSURL *)thumbImageURL:(int)px;

@end

NS_ASSUME_NONNULL_END
