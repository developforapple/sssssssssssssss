//
//  YGTabBarCtrl.m
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGTabBarCtrl.h"

@interface YGTabBarCtrl () <UITabBarControllerDelegate>

@end

@implementation YGTabBarCtrl

+ (instancetype)getDefaultTabBarCtrl
{
    static YGTabBarCtrl *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YGTabBarCtrl instanceFromStoryboard];
        instance.delegate = instance;
    });
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UINavigationController *navi in self.viewControllers) {
        if ([navi isKindOfClass:[UINavigationController class]]) {
            navi.delegate = self;
        }
    }
}

- (UINavigationController *)navigationOfTab:(SPTabType)type
{
    NSArray *vcs = [self viewControllers];
    if (type < vcs.count) {
        return vcs[type];
    }
    return nil;
}

- (UITabBarItem *)tabBarItemOfTab:(SPTabType)type
{
    NSArray *items = self.tabBar.items;
    if (type < items.count) {
        return items[type];
    }
    return nil;
}

- (void)rootViewControllerDidAppear:(UINavigationController *)navi YG_Abstract_Method
{
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{


}

#pragma mark - UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == navigationController.viewControllers.firstObject) {
        [self rootViewControllerDidAppear:navigationController];
    }
}

@end
