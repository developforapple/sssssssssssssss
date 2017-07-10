//
//  UINavigationController+Convenience.m
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UINavigationController+Convenience.h"

@implementation UINavigationController (Convenience)

- (__kindof UIViewController *)firstViewControllerOfClass:(Class)cls
{
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:cls]) {
            return vc;
        }
    }
    return nil;
}

- (NSInteger)firstViewControllerIndexOfClass:(Class)cls
{
    UIViewController *vc = [self firstViewControllerOfClass:cls];
    if (vc) {
        return [[self viewControllers] indexOfObject:vc];
    }
    return NSNotFound;
}

- (NSArray *)viewControllersBeforeClass:(Class)cls
{
    NSInteger idx = [self firstViewControllerIndexOfClass:cls];
    if (idx != NSNotFound) {
        return [self.viewControllers subarrayWithRange:NSMakeRange(0, idx)];
    }
    return nil;
}

- (NSArray *)viewControllersBeforeAndIncludeClass:(Class)cls
{
    NSInteger idx = [self firstViewControllerIndexOfClass:cls];
    if (idx != NSNotFound) {
        return [self.viewControllers subarrayWithRange:NSMakeRange(0, idx+1)];
    }
    return nil;
}

- (void)redirectToViewController:(UIViewController *)viewController
{
    [self redirectToViewController:viewController animated:YES];
}

- (void)redirectToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController || ![viewController isKindOfClass:[UIViewController class]]) return;
    
    if (self.viewControllers.count == 0) {
        [self pushViewController:viewController animated:animated];
        return;
    }
    
    if ([self.viewControllers containsObject:viewController]) {
        [self popToViewController:viewController animated:animated];
        return;
    }
    
    NSMutableArray *viewCtrls = [NSMutableArray arrayWithArray:[self.viewControllers subarrayWithRange:NSMakeRange(0, self.viewControllers.count-1)]];
    [viewCtrls addObject:viewController];
    [self setViewControllers:viewCtrls animated:animated];
}

- (void)replaceViewControllr:(UIViewController *)viewController to:(UIViewController *)newViewController
{
    [self replaceViewControllr:viewController to:newViewController animated:YES];
}

- (void)replaceViewControllr:(UIViewController *)viewController to:(UIViewController *)newViewController animated:(BOOL)animated
{
    if (!newViewController || ![viewController isKindOfClass:[UIViewController class]] || ![newViewController isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    NSArray *viewCtrls = self.viewControllers;
    NSInteger index = [viewCtrls indexOfObject:viewController];
    if ( !viewController || index == NSNotFound) {
        
        [self pushViewController:newViewController animated:animated];
        
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:viewCtrls];
    [array replaceObjectAtIndex:index withObject:newViewController];
    [self setViewControllers:array animated:animated];
}

@end
