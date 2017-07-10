//
//  YGFoundationCategories.h
//  Golf
//
//  Created by bo wang on 16/6/20.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#ifndef YGFoundationCategories_h
#define YGFoundationCategories_h

#import "NSObject+YGPerformBlock.h"
#import "NSString+STRegex.h"
#import "NSString+Utils.h"
#import "NSCalendar+YGCategory.h"
#import "NSObject+KVCExceptionCatch.h"
#import "UIDevice+Ext.h"
#import "NSArray+YYModelExt.h"

#if __has_include(<YYText/YYText.h>)
    #import <YYText/NSAttributedString+YYText.h>
    #import <YYText/NSParagraphStyle+YYText.h>
    #import <YYText/UIPasteboard+YYText.h>
#endif

#if __has_include(<YYModel/YYModel.h>)
    #import <YYModel/NSObject+YYModel.h>
#endif

#endif /* YGFoundationCategories_h */
