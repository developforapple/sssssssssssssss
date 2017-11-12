//
//  YGBaseViewCtrl.m
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGBaseViewCtrl.h"

@interface YGBaseViewCtrl () <UIGestureRecognizerDelegate>

@end

@implementation YGBaseViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        if (self.navigationController.viewControllers.firstObject != self) {
            [self leftNavButtonTemplateImg:@"icon_back_dark"];
        }
        
        // 解决iOS11导航栏左侧按钮无响应的问题
        if (iOS11) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)dealloc
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

- (void)leftNavButtonImg:(NSString*)img
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStylePlain target:self action:@selector(doLeftNaviBarItemAction)];
}

- (void)rightNavButtonImg:(NSString*)img
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:img] style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
}

- (void)leftNavButtonTemplateImg:(NSString*)img
{
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doLeftNaviBarItemAction)];
}

- (void)rightNavButtonTemplateImg:(NSString*)img
{
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
}

- (void)rightNavButtonText:(NSString *)text
{
    if (text) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(doRightNaviBarItemAction)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)doLeftNaviBarItemAction
{
    if (self.navigationController.viewControllers.firstObject == self &&
        self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)doRightNaviBarItemAction
{
    
}

- (void)noLeftNavButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)setTitleImage:(NSString *)img
{
    UIImage *image = [UIImage imageNamed:img];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
}

@end
