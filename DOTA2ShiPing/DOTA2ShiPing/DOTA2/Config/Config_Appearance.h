//
//  Config_Appearance.h
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Config_Appearance_h
#define Config_Appearance_h

#include "Defines.h"
#include "ConfigDefines.h"

@class UIColor;

// 主题蓝色系
YG_EXTERN UIColor *kBlueColor;            //主题颜色 0484FA
YG_EXTERN UIColor *kBlueColorBegin;      //蓝色范围起始 00a0f7
YG_EXTERN UIColor *kBlueColorEnd;        //蓝色范围结束 2869db

// 辅助红色系
YG_EXTERN UIColor *kRedColor;             //主红色   f62971
YG_EXTERN UIColor *kRedColorBegin;        //红色范围起始    f34535
YG_EXTERN UIColor *kRedColorEnd;          //红色范围结束    b3048e

// 辅助橙色系
YG_EXTERN UIColor *kOrgColor;             //橙色    ff4000

// 灰色系
YG_EXTERN UIColor *kTextColor;            //文本颜色  444444
YG_EXTERN UIColor *kSubTextColor;         //次级颜色  999999
YG_EXTERN UIColor *kLightTextColor;       //很淡的文本颜色 C9C9C9

YG_EXTERN UIColor *kLineColor;            //细线    F5F5F5
YG_EXTERN UIColor *kDisableColor;         //失效状态背景  dadada


YG_EXTERN UIColor *kBarTintColor;
YG_EXTERN UIColor *kTintColor;


#endif /* Config_Appearance_h */
