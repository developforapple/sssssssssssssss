//
//  YGBaseViewCtrl.h
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@interface YGBaseViewCtrl : UIViewController

- (void)leftNavButtonImg:(NSString *)img;
- (void)rightNavButtonImg:(NSString *)img;
- (void)leftNavButtonTemplateImg:(NSString *)img;
- (void)rightNavButtonTemplateImg:(NSString *)img;
- (void)rightNavButtonText:(NSString *)text;
- (void)rightNavSystemItem:(UIBarButtonSystemItem)item;
- (void)doLeftNaviBarItemAction;
- (void)doRightNaviBarItemAction;
- (void)noLeftNavButton;

- (void)setTitleImage:(NSString *)img;

@end
