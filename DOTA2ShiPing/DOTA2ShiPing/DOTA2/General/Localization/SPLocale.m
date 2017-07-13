//
//  SPLocale.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPLocale.h"

@implementation SPLocale

+ (NSArray *)supportedLanguages
{
    static NSArray *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[kLangSchinese];
    });
    return array;
}

+ (BOOL)isLangSupported:(NSString *)lang
{
    if (!lang) return NO;
    return [[self supportedLanguages] containsObject:lang];
}

+ (NSString *)preferLanguages
{
    NSString *lang;
    NSArray *languages = [NSLocale preferredLanguages];
    
    for (NSString *aLang in languages) {
        
        if ([aLang isEqualToString:@"zh"] || [aLang hasPrefix:@"zh-"] || [aLang hasPrefix:@"zh_"]) {
            if ([self isLangSupported:kLangSchinese]) {
                lang = kLangSchinese;
                break;
            }
        }else
        
        if ([aLang isEqualToString:@"en"] || [aLang hasPrefix:@"en-"] || [aLang hasPrefix:@"en_"]){
            if ([self isLangSupported:kLangEnglish]) {
                lang = kLangEnglish;
            }
            break;
        }
    }
    if (!lang) {
        lang = kLangEnglish;
    }
    return lang;
}

@end

NSString *const kLangSchinese = @"schinese";
NSString *const kLangEnglish = @"english";
