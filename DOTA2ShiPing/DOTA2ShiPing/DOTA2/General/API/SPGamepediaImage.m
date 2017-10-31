//
//  SPGamepediaImage.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaImage.h"

@interface SPGamepediaImage ()
@property (copy, readwrite, nonatomic) NSString *scheme;
@property (copy, readwrite, nonatomic) NSString *host;
@property (copy, readwrite, nonatomic) NSString *path;
@property (copy, readwrite, nonatomic) NSString *filepath;
@property (copy, readwrite, nonatomic) NSString *filename;
@property (copy, readwrite, nonatomic) NSString *version;
@end

@implementation SPGamepediaImage

+ (instancetype)gamepediaImage:(NSString *)src
{
    NSURLComponents *url = [NSURLComponents componentsWithString:src];
    if (!url) {
        return nil;
    }
    
    SPGamepediaImage *image = [SPGamepediaImage new];
    image.scheme = url.scheme;
    image.host = url.host;
    
    NSString *path = url.path;
    
    NSRange thumbRange = [path rangeOfString:@"/thumb"];
    if (thumbRange.location == NSNotFound) {
        NSRange r = [path rangeOfString:@"dota2.gamepedia.com"];
        if (r.location == NSNotFound) {
            return nil;
        }
        image.path = [path substringToIndex:NSMaxRange(r)];
        
        NSString *tmp = [path substringFromIndex:NSMaxRange(r)];
        NSArray *pathCompontents = [tmp componentsSeparatedByString:@"/"];
        if (pathCompontents.count >= 3) {
            image.filepath = [pathCompontents[0] stringByAppendingPathComponent:pathCompontents[1]];
            image.filename = pathCompontents[2];
        }
        
    }else{
        image.path = [path substringToIndex:thumbRange.location];
        NSString *tmp = [path substringFromIndex:NSMaxRange(thumbRange)+1];
        NSArray *pathCompontents = [tmp componentsSeparatedByString:@"/"];
        if (pathCompontents.count >= 3) {
            image.filepath = [pathCompontents[0] stringByAppendingPathComponent:pathCompontents[1]];
            image.filename = pathCompontents[2];
        }
    }
    
    for (NSURLQueryItem *aItem in url.queryItems) {
        if ([aItem.name isEqualToString:@"version"]) {
            image.version = aItem.value;
            break;
        }
    }
    
    return image;
}

- (NSURL *)fullsizeImageURL
{
    return [self thumbImageURL:0];
}

- (NSURL *)thumbImageURL:(int)px
{
    NSURLComponents *compontents = [NSURLComponents new];
    compontents.scheme = self.scheme;
    compontents.host = self.host;
    
    if (px > 0) {
        
        NSString *path = [[[[self.path  stringByAppendingPathComponent:@"thumb"]
                                        stringByAppendingPathComponent:self.filepath]
                                        stringByAppendingPathComponent:self.filename]
                                        stringByAppendingPathComponent:[NSString stringWithFormat:@"%dpx-%@",px,self.filename]];
        compontents.path = path;
        
    }else{
        NSString *path = [[self.path  stringByAppendingPathComponent:self.filepath]
                                      stringByAppendingPathComponent:self.filename];
        compontents.path = path;
    }
    
    if (self.version.length) {
        compontents.queryItems = @[[NSURLQueryItem queryItemWithName:@"version" value:self.version]];
    }
    
    return compontents.URL;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ URL:%@",[super description],[self fullsizeImageURL]];
}

@end


