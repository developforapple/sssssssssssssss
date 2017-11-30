//
//  SKPaymentTransaction+SPMore.h
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import <StoreKit/StoreKit.h>
@import AVOSCloud.AVObject;

@interface SKPaymentTransaction (SPMore)

- (void)setAVObject:(AVObject *)object;
- (AVObject *)avobject;

@end
