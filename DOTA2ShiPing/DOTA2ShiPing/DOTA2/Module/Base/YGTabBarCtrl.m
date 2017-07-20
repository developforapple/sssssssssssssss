//
//  YGTabBarCtrl.m
//
//  Created by WangBo on 2017/3/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGTabBarCtrl.h"
//#import "BingoLoginNaviCtrl.h"

@interface YGTabBarCtrl () <UITabBarControllerDelegate>

@end

@implementation YGTabBarCtrl

+ (instancetype)defaultTabBarCtrl
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
}

- (UINavigationController *)navigationOfTab:(BingoTabType)type
{
    NSArray *vcs = [self viewControllers];
    if (type < vcs.count) {
        return vcs[type];
    }
    return nil;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

@end
