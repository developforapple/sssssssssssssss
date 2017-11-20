//
//  YGBaseViewCtrl.m
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@interface UIViewController (YGBase) <UIGestureRecognizerDelegate>
@end

@implementation UIViewController (YGBase)

- (void)_onViewDidLoad
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        if (self.navigationController.viewControllers.firstObject != self) {
            [self _leftNavButtonTemplateImg:@"icon_back_dark"];
        }
        
        // 解决iOS11导航栏左侧按钮无响应的问题
        if (iOS11) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)_onViewWillAppear:(BOOL)animated
{}

- (void)_onViewDidAppear:(BOOL)animated
{}

- (void)_onViewWillDisappear:(BOOL)animated
{}

- (void)_onViewDidDisappear:(BOOL)animated
{}

- (void)_onDealloc
{
    if (IS_iOS8) {
        //iOS8下的一个bug
        NSArray *subViews = self.view.subviews;
        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UITableView class]]) {
                [(UITableView *)view setDelegate:nil];
                [(UITableView *)view setDataSource:nil];
            }
        }
    }
    NSLog(@"%@ 释放",NSStringFromClass([self class]));
}

- (void)_leftNavButtonImg:(NSString*)img
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStylePlain target:self action:@selector(doLeftNaviBarItemAction)];
}

- (void)_rightNavButtonImg:(NSString*)img
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
}

- (void)_leftNavButtonTemplateImg:(NSString*)img
{
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doLeftNaviBarItemAction)];
}

- (void)_rightNavButtonTemplateImg:(NSString*)img
{
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
}

- (void)_rightNavButtonText:(NSString *)text
{
    if (text) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)_rightNavSystemItem:(UIBarButtonSystemItem)item
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(doRightNaviBarItemAction)];
}

- (void)_doLeftNaviBarItemAction
{
    if (self.navigationController.viewControllers.firstObject == self &&
        self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_doRightNaviBarItemAction
{
    
}

- (void)_noLeftNavButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)_setTitleImage:(NSString *)img
{
    UIImage *image = [UIImage imageNamed:img];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
}

@end

@interface YGBaseViewCtrl () <UIGestureRecognizerDelegate>

@end

@implementation YGBaseViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _onViewDidLoad];
}

- (void)dealloc
{
    [self _onDealloc];
}

- (void)leftNavButtonImg:(NSString *)img
{
    [self _leftNavButtonImg:img];
}

- (void)rightNavButtonImg:(NSString *)img
{
    [self _rightNavButtonImg:img];
}

- (void)leftNavButtonTemplateImg:(NSString *)img
{
    [self _leftNavButtonTemplateImg:img];
}

- (void)rightNavButtonTemplateImg:(NSString *)img
{
    [self _rightNavButtonTemplateImg:img];
}

- (void)rightNavButtonText:(NSString *)text
{
    [self _rightNavButtonText:text];
}

- (void)rightNavSystemItem:(UIBarButtonSystemItem)item
{
    [self _rightNavSystemItem:item];
}

- (void)doLeftNaviBarItemAction
{
    [self _doLeftNaviBarItemAction];
}

- (void)doRightNaviBarItemAction
{
    [self _doRightNaviBarItemAction];
}

- (void)noLeftNavButton
{
    [self _noLeftNavButton];
}

@end

@implementation YGBaseTableViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _onViewDidLoad];
}

- (void)dealloc
{
    [self _onDealloc];
}

- (void)leftNavButtonImg:(NSString *)img
{
    [self _leftNavButtonImg:img];
}

- (void)rightNavButtonImg:(NSString *)img
{
    [self _rightNavButtonImg:img];
}

- (void)leftNavButtonTemplateImg:(NSString *)img
{
    [self _leftNavButtonTemplateImg:img];
}

- (void)rightNavButtonTemplateImg:(NSString *)img
{
    [self _rightNavButtonTemplateImg:img];
}

- (void)rightNavButtonText:(NSString *)text
{
    [self _rightNavButtonText:text];
}

- (void)rightNavSystemItem:(UIBarButtonSystemItem)item
{
    [self _rightNavSystemItem:item];
}

- (void)doLeftNaviBarItemAction
{
    [self _doLeftNaviBarItemAction];
}

- (void)doRightNaviBarItemAction
{
    [self _doRightNaviBarItemAction];
}

- (void)noLeftNavButton
{
    [self _noLeftNavButton];
}

@end

@implementation YGBaseCollectionViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _onViewDidLoad];
}

- (void)dealloc
{
    [self _onDealloc];
}

- (void)leftNavButtonImg:(NSString *)img
{
    [self _leftNavButtonImg:img];
}

- (void)rightNavButtonImg:(NSString *)img
{
    [self _rightNavButtonImg:img];
}

- (void)leftNavButtonTemplateImg:(NSString *)img
{
    [self _leftNavButtonTemplateImg:img];
}

- (void)rightNavButtonTemplateImg:(NSString *)img
{
    [self _rightNavButtonTemplateImg:img];
}

- (void)rightNavButtonText:(NSString *)text
{
    [self _rightNavButtonText:text];
}

- (void)rightNavSystemItem:(UIBarButtonSystemItem)item
{
    [self _rightNavSystemItem:item];
}

- (void)doLeftNaviBarItemAction
{
    [self _doLeftNaviBarItemAction];
}

- (void)doRightNaviBarItemAction
{
    [self _doRightNaviBarItemAction];
}

- (void)noLeftNavButton
{
    [self _noLeftNavButton];
}
@end
