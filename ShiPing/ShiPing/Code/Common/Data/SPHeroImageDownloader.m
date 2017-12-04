//
//  SPHeroImageDownloader.m
//  ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPHeroImageDownloader.h"

@implementation SPHeroImageDownloader

+ (void)downloadImages
{
    NSString *folder = @"/Users/wangbo/Desktop/DOTA.tmp/image/hero";
    
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/wangbo/Desktop/DOTA.tmp/basedata/data.json"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *heroes = dict[@"heroes"];
    
    NSLog(@"%d",heroes.count);
    
    NSInteger i = 0;
    
    for (NSDictionary *aHero in heroes) {
        NSString *name = aHero[@"name"];
        NSRange range = [name rangeOfString:@"npc_dota_hero_"];
        if (range.location != NSNotFound) {
            NSString *heroName = [name substringFromIndex:range.location + range.length];
            
            
            // full image
            {
                NSString *url = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_full.png",heroName];
                NSError *error;
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:nil error:&error];
                
                
                
                NSString *filePath = [folder stringByAppendingPathComponent:name];
                [data writeToFile:filePath atomically:YES];
                if (error) {
                    NSLog(@"%@, error:%@",name,error);
                }
                NSLog(@"%d / %d",++i,heroes.count);
            }
        
            // vert image
            {
                NSString *url = [NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/heroes/%@_vert.jpg",heroName];
                NSError *error;
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:nil error:&error];
                NSString *filePath = [folder stringByAppendingPathComponent:[name stringByAppendingString:@"_vert"]];
                [data writeToFile:filePath atomically:YES];
                if (error) {
                    NSLog(@"%@, error:%@",name,error);
                }
                NSLog(@"%d / %d",++i,heroes.count);
            }
            
            // icon
            {
                NSString *url = [NSString stringWithFormat:@"http://www.dota2.com.cn/images/heroes/%@_icon.png",heroName];
                NSError *error;
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:nil error:&error];
                NSString *filePath = [folder stringByAppendingPathComponent:[name stringByAppendingString:@"_icon"]];
                [data writeToFile:filePath atomically:YES];
                if (error) {
                    NSLog(@"%@, error:%@",name,error);
                }
                NSLog(@"%d / %d",++i,heroes.count);
            }
        }
    }
    
    NSLog(@"done");
}

@end
