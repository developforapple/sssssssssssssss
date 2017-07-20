//
//  SPItemTransition.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/19.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPItemTransition : NSObject <UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

+ (instancetype)transition;

@end
