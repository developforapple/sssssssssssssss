//
//  YGBaseViewCtrl.h
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

@import UIKit;

@protocol UIViewControllerBaseMethod <NSObject>

- (void)leftNavButtonImg:(NSString *)img;
- (void)rightNavButtonImg:(NSString *)img;
- (void)leftNavButtonTemplateImg:(NSString *)img;
- (void)rightNavButtonTemplateImg:(NSString *)img;
- (void)rightNavButtonText:(NSString *)text;
- (void)rightNavSystemItem:(UIBarButtonSystemItem)item;
- (void)doLeftNaviBarItemAction YG_Abstract_Method;
- (void)doRightNaviBarItemAction YG_Abstract_Method;
- (void)noLeftNavButton;

- (void)transitionLayoutToSize:(CGSize)size YG_Abstract_Method;

@end

@interface YGBaseViewCtrl : UIViewController <UIViewControllerBaseMethod>
- (IBAction)doLeftNaviBarItemAction;
@end

@interface YGBaseTableViewCtrl : UITableViewController <UIViewControllerBaseMethod>
- (IBAction)doLeftNaviBarItemAction;
@end

@interface YGBaseCollectionViewCtrl : UICollectionViewController <UIViewControllerBaseMethod>
- (IBAction)doLeftNaviBarItemAction;
@end
