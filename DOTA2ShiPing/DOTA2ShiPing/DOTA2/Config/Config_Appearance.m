//
//  Config_Appearance.c
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#include "Config_Appearance.h"
#import "ChameleonMacros.h"

// 主题蓝色系
UIColor *kBlueColor;            //主题颜色 0484FA
UIColor *kBlueColorBegin;      //蓝色范围起始 00a0f7
UIColor *kBlueColorEnd;        //蓝色范围结束 2869db

// 辅助红色系
UIColor *kRedColor;             //主红色   f62971
UIColor *kRedColorBegin;        //红色范围起始    f34535
UIColor *kRedColorEnd;          //红色范围结束    b3048e

// 辅助橙色系
UIColor *kOrgColor;             //橙色    ff4000

// 灰色系
UIColor *kTextColor;            //文本颜色  444444
UIColor *kSubTextColor;         //次级颜色  999999
UIColor *kLightTextColor;       //很淡的文本颜色 C9C9C9

UIColor *kLineColor;            //细线    F5F5F5
UIColor *kDisableColor;         //失效状态背景  dadada

UIColor *kBarTintColor;
UIColor *kTintColor;

@interface _Config_Appearance : NSObject

@end

@implementation _Config_Appearance

+ (void)load
{
    kBlueColor      = [UIColor colorWithHexString:@"0484FA"];
    kBlueColorBegin = [UIColor colorWithHexString:@"00a0f7"];
    kBlueColorEnd   = [UIColor colorWithHexString:@"2869db"];
    
    kRedColor       = [UIColor colorWithHexString:@"f62971"];
    kRedColorBegin  = [UIColor colorWithHexString:@"f34535"];
    kRedColorEnd    = [UIColor colorWithHexString:@"b3048e"];
    
    kOrgColor       = [UIColor colorWithHexString:@"ff4000"];
    
    kTextColor      = [UIColor colorWithHexString:@"444444"];
    kSubTextColor   = [UIColor colorWithHexString:@"999999"];
    kLightTextColor = [UIColor colorWithHexString:@"C9C9C9"];
    
    kLineColor      = [UIColor colorWithHexString:@"F5F5F5"];
    kDisableColor   = [UIColor colorWithHexString:@"dadada"];
    
    kBarTintColor = FlatNavyBlueDark;
    kTintColor = FlatWhite;
}

@end
