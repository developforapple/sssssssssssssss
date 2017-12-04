//
//  SPItemImageDownloader.h
//  ShiPing
//
//  Created by wwwbbat on 2017/7/17.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItemImageDownloader : NSObject

+ (void)download:(NSString *)dbPath;


+ (void)compressImages;


@end
