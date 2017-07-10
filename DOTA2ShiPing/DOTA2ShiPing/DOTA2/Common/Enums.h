//
//  Enums.h
//
//  Created by WangBo on 2017/4/19.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

typedef NS_ENUM(NSUInteger, CDTLineType) {
    CDTLineTypeApple = 1,
    CDTLineTypeAndriod = 3,
    CDTLineTypeTypeC = 4,
};

typedef NS_ENUM(NSUInteger, CDTPayPlatform) {
    CDTPayPlatformNone = 0,
    CDTPayPlatformWechat = 1,
    CDTPayPlatformAlipay = 2,
    CDTPayPlatformLaidian = 999,
};

typedef NS_ENUM(NSUInteger, CDTTaskType) {
    CDTTaskTypeRentCDB = 1,
    CDTTaskTypeBuyLine = 2,
};

typedef NS_ENUM(NSUInteger, CDTQRCodeType) {
    CDTQRCodeTypeUnsupport = 0, //不支持的类型
    CDTQRCodeTypeTerminal = 1,  //终端二维码
    CDTQRCodeTypeCoupon = 2,    //优惠券二维码
    CDTQRCodeTypeZMB = 3,       //桌面宝终端二维码
    
    CDTQRCodeTypeLaidian = 10,   //来电网页
    CDTQRCodeTypeWechat = 11,    //微信网页
    CDTQRCodeTypeOther = 12,     //其他网页
};

typedef NS_ENUM(NSUInteger, CDTNearbyItemType) {
    CDTNearbyItemTypeAll = 0,   //全部
    CDTNearbyItemTypeCDB = 1,   //充电宝
    CDTNearbyItemTypeZMB = 2,   //桌面宝
};

typedef NS_OPTIONS(NSInteger, CDBType) {
    CDBTypeNone = 0,           //未选择
    
    CDBTypeClassic = 1 << 0,   //旧充电宝
    CDBTypeLightning = 1 << 1, //带苹果线的充电宝
    CDBTypeAndroid = 1 << 2,   //带安卓线的充电宝
    CDBTypeTypeC = 1 << 3,     //带Type-C线的充电宝
    
    CDBTypeAll = CDBTypeClassic | CDBTypeLightning | CDBTypeAndroid | CDBTypeTypeC,
};

#endif /* Enums_h */
