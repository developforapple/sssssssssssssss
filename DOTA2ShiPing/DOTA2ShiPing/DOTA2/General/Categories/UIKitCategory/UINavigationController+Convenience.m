//
//  UINavigationController+Convenience.m
//  Golf
//
//  Created by bo wang on 2017/3/24.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UINavigationController+Convenience.h"

@implementation UINavigationController (Convenience)

- (nullable UIViewController *)firstOne:(Class)cls
{
    return [[self findAll:cls] firstObject];
}

- (nullable UIViewController *)lastOne:(Class)cls
{
    return [[self findAll:cls] lastObject];
}

- (nullable NSArray *)findAll:(Class)cls
{
    if (!cls) return nil;
    return [self.viewControllers objectsAtIndexes:[self.viewControllers indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:cls];
    }]];
}

- (nullable UIViewController *)previousOne:(UIViewController *)viewCtrl
{
    return [[self previousAll:viewCtrl] lastObject];
}

- (nullable UIViewController *)nextOne:(UIViewController *)viewCtrl
{
    return [[self nextAll:viewCtrl] firstObject];
}

- (nullable NSArray *)previousAll:(UIViewController *)viewCtrl
{
    if (!viewCtrl) return nil;
    NSInteger index = [self.viewControllers indexOfObject:viewCtrl];
    if (index == NSNotFound) return nil;
    return [self.viewControllers subarrayWithRange:NSMakeRange(0, index)];
}

- (nullable NSArray *)nextAll:(UIViewController *)viewCtrl
{
    if (!viewCtrl) return nil;
    NSInteger index = [self.viewControllers indexOfObject:viewCtrl];
    if (index == NSNotFound) return nil;
    if (viewCtrl == self.topViewController) return @[];
    NSInteger loc = index+1;
    NSInteger len = self.viewControllers.count-loc;
    return [self.viewControllers subarrayWithRange:NSMakeRange(loc, len)];
}

#pragma mark - Redirect
- (void)replace:(UIViewController *)viewCtrl to:(UIViewController *)newViewCtrl
{
    if (!viewCtrl || !newViewCtrl) return;
    
    if ([self.viewControllers containsObject:newViewCtrl]) return;
    
    NSInteger index = [self.viewControllers indexOfObject:viewCtrl];
    if (index == NSNotFound) return;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
    [array replaceObjectAtIndex:index withObject:newViewCtrl];
    [self setViewControllers:array animated:NO];
}

- (void)redirectTopViewCtrlTo:(UIViewController *)viewCtrl
{
    [self redirectTopViewCtrlTo:viewCtrl animated:YES];
}

- (void)redirectTopViewCtrlTo:(UIViewController *)viewCtrl animated:(BOOL)animated
{
    if ([self.viewControllers containsObject:viewCtrl]) {
        [self popToViewController:viewCtrl animated:animated];
    }else{
        UIViewController *top = self.topViewController;
        [self yg_push:viewCtrl afterPopOutViewCtrl:top];
    }
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopToClass:(Class)popToCls
{
    [self yg_push:viewCtrl afterPopToClass:popToCls animated:YES];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopToClass:(Class)popToCls animated:(BOOL)animated
{
    UIViewController *popToViewCtrl = [self firstOne:popToCls];
    [self yg_push:viewCtrl afterPopToViewCtrl:popToViewCtrl animated:animated];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopToViewCtrl:(UIViewController *)popToViewCtrl
{
    [self yg_push:viewCtrl afterPopToViewCtrl:popToViewCtrl animated:YES];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopToViewCtrl:(UIViewController *)popToViewCtrl animated:(BOOL)animated
{
    if (!viewCtrl) return;
    if ([self.viewControllers containsObject:viewCtrl]) return;
    if (!popToViewCtrl) {
        [self pushViewController:viewCtrl animated:animated];
        return;
    }
    
    NSInteger index = [self.viewControllers indexOfObject:popToViewCtrl];
    if (index == NSNotFound) {
        [self pushViewController:viewCtrl animated:animated];
    }else{
        NSMutableArray *viewCtrls = [NSMutableArray arrayWithArray:[self.viewControllers subarrayWithRange:NSMakeRange(0, index+1)]];
        [viewCtrls addObject:viewCtrl];
        [self setViewControllers:viewCtrls animated:animated];
    }
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopOutClass:(Class)popOutCls
{
    [self yg_push:viewCtrl afterPopOutClass:popOutCls animated:YES];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopOutClass:(Class)popOutCls animated:(BOOL)animated
{
    UIViewController *popOutViewCtrl = [self firstOne:popOutCls];
    [self yg_push:viewCtrl afterPopOutViewCtrl:popOutViewCtrl animated:animated];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopOutViewCtrl:(UIViewController *)popOutViewCtrl
{
    [self yg_push:viewCtrl afterPopOutViewCtrl:popOutViewCtrl animated:YES];
}

- (void)yg_push:(UIViewController *)viewCtrl afterPopOutViewCtrl:(UIViewController *)popOutViewCtrl animated:(BOOL)animated
{
    UIViewController *previousViewCtrl = [self previousOne:popOutViewCtrl];
    [self yg_push:viewCtrl afterPopToViewCtrl:previousViewCtrl animated:animated];
}


@end
