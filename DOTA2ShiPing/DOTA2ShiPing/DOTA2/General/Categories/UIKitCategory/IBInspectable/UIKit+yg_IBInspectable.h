//
//  UIKit+yg_IBInspectable.h
//  Golf
//
//  Created by bo wang on 16/6/29.
//  Copyright © 2016年 WangBo. All rights reserved.
//


@import UIKit;

#import "UIView+yg_IBInspectable.h"
#import "UIButton+yg_IBInspectable.h"
#import "UISearchBar+yg_IBInspectable.h"
#import "UITableView+yg_IBInspectable.h"
#import "UITableViewCell+yg_IBInspectable.h"
#import "UICollectionViewCell+yg_IBInspectable.h"
#import "UINavigationBar+yg_IBInspectable.h"
#import "UIToolbar+yg_IBInspectable.h"
#import "UITabBar+yg_IBInspectable.h"
#import "UIActivityIndicatorView+yg_IBInspectable.h"
#import "UIViewController+yg_IBInspectable.h"
#import "UIScrollView+yg_IBInspectable.h"

/*!
 *  这里设置了很多可以在IB中使用的可设值的属性。在IB中设定值后，将会在运行时自动使用 KVC 调用属性的setter方法。
 *  所以这里每个属性都必须实现其 setter 方法。
 *
 *  IBInspectable 可以使用的类型：整形、浮点、BOOL、UIColor、CGSize、CGRect、NSRange、CGPoint、UIImage、NSString
 *  
 *  NSObject+KVCExceptionCatch.h 中对异常进行了处理，通过断言发现错误的key值，保障不会出现crash。
 */



