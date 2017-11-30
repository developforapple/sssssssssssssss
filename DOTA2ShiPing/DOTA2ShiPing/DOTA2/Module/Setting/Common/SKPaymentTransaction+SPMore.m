//
//  SKPaymentTransaction+SPMore.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/12/1.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SKPaymentTransaction+SPMore.h"

static void *kAVObjectKey = &kAVObjectKey;

@implementation SKPaymentTransaction (SPMore)

- (void)setAVObject:(AVObject *)object
{
    objc_setAssociatedObject(self, kAVObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AVObject *)avobject
{
    return objc_getAssociatedObject(self, kAVObjectKey);
}

@end
