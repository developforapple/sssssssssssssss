//
//  YGTextField.h
//  Golf
//
//  Created by bo wang on 2016/11/7.
//  Copyright © 2016年 WangBo. All rights reserved.
//

@import UIKit;


@interface YGTextField : UITextField

// 是否有长按菜单
@property (assign, nonatomic) IBInspectable BOOL longPressEnabled;

@property (strong, nonatomic) IBInspectable UIColor *placeholderColor;
@property (assign, nonatomic) IBInspectable UIColor *cursorColor;

// 如果指定了 next 并且returnType 为 nextType，next将会成为下一个响应者。
@property (weak, nonatomic) IBOutlet UIResponder *next;
@property (copy, nonatomic) BOOL (^shouldReturn)(YGTextField *tf);

@end
