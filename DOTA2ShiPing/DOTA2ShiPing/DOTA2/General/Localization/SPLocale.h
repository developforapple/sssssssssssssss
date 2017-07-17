//
//  SPLocale.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/13.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPLocale : NSObject

+ (NSArray *)supportedLanguages;
+ (BOOL)isLangSupported:(NSString *)lang;

// app优先使用的语言
+ (NSString *)preferLanguages;

// app当前使用的语言
+ (NSString *)curLanguage;
+ (void)changeLanguage:(NSString *)lang;

@end

#define GetLang         [SPLocale curLanguage]
#define SetLang(lang)   [SPLocale changeLanguage:(lang)]



YG_EXTERN NSString *const kLangSchinese;
YG_EXTERN NSString *const kLangEnglish;
