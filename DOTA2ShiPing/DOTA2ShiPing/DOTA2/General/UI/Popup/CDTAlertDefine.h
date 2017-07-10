//
//  CDTAlertDefine.h
//  CDT
//
//  Created by wwwbbat on 2017/5/12.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

@import Foundation;
#import "CDTAlertAction.h"

typedef NS_ENUM(NSUInteger, CDTAlertType) {
    
    CDTAlertCustom = 0,         //自定义内容
    
    CDTAlertSuccess = 10,       //成功
    CDTAlertFail,               //失败
    CDTAlertInfo,               //提示
    
    CDTAlertNetworkErr
};

@interface CDTAlertDefine : NSObject

- (instancetype)initWithType:(CDTAlertType)type;

@property (assign, readonly, nonatomic) CDTAlertType type;
@property (copy, readwrite, nonatomic) UIImage *image;

// 可以修改文本内容。message根据type具有默认值
@property (copy, nonatomic) NSString *message;
// actions默认为nil，需要手动设置,最多支持2个按钮。
@property (strong, nonatomic) NSArray<CDTAlertAction *> *actions;

@end
