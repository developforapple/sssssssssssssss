//
//  YGAreaPickerView.h
//  Golf
//
//  Created by bo wang on 2016/11/30.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import UIKit;
#import "YGAreaManager.h"

@interface YGAreaPickerView : UIView

//默认216高度
+ (instancetype)pickerView;

// 是否显示区。默认为YES。
@property (assign, nonatomic) BOOL showDistrict;

@property (strong, readonly, nonatomic) YGArea *area;

- (void)reload;

- (void)setupWithArea:(YGArea *)area;

- (YGArea *)currentArea;
- (YGAreaProvince *)currentProvince;
- (YGAreaCity *)currentCity;
- (YGAreaDistrict *)currentDistrict;

@end
