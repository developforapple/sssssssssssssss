//
//  SPItemTransition.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/19.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemTransition.h"
#import "SPItemsDetailViewCtrl.h"
#import "SPItemListVC.h"

@implementation SPItemTransition

+ (instancetype)transition
{
    static SPItemTransition *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPItemTransition new];
    });
    return instance;
}


#pragma mark - UINavigationController

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush){
        if ([toVC isKindOfClass:[SPItemsDetailViewCtrl class]]) {
            //push到详情
            return [SPItemTransition transition];
        }
    }else if (operation == UINavigationControllerOperationPop){
        if ([fromVC isKindOfClass:[SPItemsDetailViewCtrl class]]) {
            //从详情pop
            return [SPItemTransition transition];
        }
    }
    return nil;
}

@end

