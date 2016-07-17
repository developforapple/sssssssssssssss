//
//  SPWorkshopTagVC.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/17.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPWorkshop.h"

typedef void(^SPWorkshopTagCompletion)(BOOL canceled,NSArray<SPWorkshopTag *> *);

@interface SPWorkshopTagVC : UINavigationController

- (void)setup:(SPWorkshop *)workshop
   completion:(SPWorkshopTagCompletion)completion;

@end
