//
//  UITableView+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;


@interface UITableView (yg_IBInspectable)

// 分割线inset是不是 zero。
@property (assign, nonatomic) IBInspectable BOOL separatorInsetZero;

// 当选中cell后，自动取消选中。相当于自动执行 deselectRowAtIndexPath:animated: 方法
// 弃用了！！！！
@property (assign, nonatomic) IBInspectable BOOL deselectRowAutomatic YG_DEPRECATED(0.0.4,"有BUG，弃用了") ;

@end
