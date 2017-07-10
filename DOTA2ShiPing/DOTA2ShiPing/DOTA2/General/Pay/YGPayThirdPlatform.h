//
//  YGPayThirdPlatform.h
//  Golf
//
//  Created by bo wang on 2016/12/5.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#ifndef YGPayThirdPlatform_h
#define YGPayThirdPlatform_h

typedef NS_ENUM(NSUInteger, YGPayThirdPlatform) {
    YGPayThirdPlatformWechat = 1,   //微信支付
    YGPayThirdPlatformAlipay = 2,   //支付宝支付
    YGPayThirdPlatformUPPay = 3,    //银联控件支付
    YGPayThirdPlatformApplePay = 4, //ApplePay
};

NS_INLINE NSString *payChannel(YGPayThirdPlatform platform){
    switch (platform) {
        case YGPayThirdPlatformWechat: return @"wx";    break;
        case YGPayThirdPlatformAlipay: return @"alipay";break;
        case YGPayThirdPlatformUPPay:   break;
        case YGPayThirdPlatformApplePay:break;
    }
    return @"";
}

NS_INLINE BOOL avaliableThirdPayPlatform(YGPayThirdPlatform platform){
    return platform == YGPayThirdPlatformWechat || platform == YGPayThirdPlatformAlipay;
}

#endif /* YGPayThirdPlatform_h */
