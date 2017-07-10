//
//  UITableView+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UITableView+yg_IBInspectable.h"
#import "ReactiveObjC.h"
#import <ReactiveObjC/RACDelegateProxy.h>
#import <ReactiveObjC/NSObject+RACDescription.h>

static const void *defaultInsetKey = &defaultInsetKey;
static const void *defaultLayoutMarginsKey = &defaultLayoutMarginsKey;

static const void *deselectRowAutomaticKey = &deselectRowAutomaticKey;

@implementation UITableView (yg_IBInspectable)

- (UIEdgeInsets)defaultInsets
{
    NSValue *v = objc_getAssociatedObject(self, defaultInsetKey);
    if (v) {
        return [v UIEdgeInsetsValue];
    }
    return self.separatorInset;
}

- (void)setDefaultInsets:(UIEdgeInsets)insets
{
    objc_setAssociatedObject(self, defaultInsetKey, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)defaultLayoutMargins
{
    NSValue *v = objc_getAssociatedObject(self, defaultLayoutMarginsKey);
    if (v) {
        return [v UIEdgeInsetsValue];
    }
    return self.separatorInset;
}

- (void)setDefaultLayoutMargins:(UIEdgeInsets)insets
{
    objc_setAssociatedObject(self, defaultLayoutMarginsKey, [NSValue valueWithUIEdgeInsets:insets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSeparatorInsetZero:(BOOL)separatorInsetZero
{
    if (separatorInsetZero) {
        [self setDefaultInsets:self.separatorInset];
        self.separatorInset = UIEdgeInsetsZero;
        if (iOS8) {
            [self setDefaultLayoutMargins:self.layoutMargins];
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }else{
        self.separatorInset = [self defaultInsets];
        if (iOS8) {
            self.layoutMargins = [self defaultLayoutMargins];
        }
    }
}
- (BOOL)separatorInsetZero
{
    return UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.separatorInset);
}

- (void)setDeselectRowAutomatic:(BOOL)deselectRowAutomatic
{
//    objc_setAssociatedObject(self, deselectRowAutomaticKey, @(deselectRowAutomatic), OBJC_ASSOCIATION_COPY_NONATOMIC);
//    
//    if (deselectRowAutomatic) {
//        bingoWeakify(self);
//        [RACObserve(self, delegate) subscribeNext:^(id x) {
//            bingoStrongify(self);
//            if (x != self.rac_delegateProxy) {
//                [self beginObserveDidSelectedRowSignal];
//            }
//        }];
//    }
}

- (BOOL)deselectRowAutomatic
{
    return [objc_getAssociatedObject(self, deselectRowAutomaticKey) boolValue];
}

//- (RACDelegateProxy *)rac_delegateProxy
//{
//    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
//    if (proxy == nil) {
//        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITableViewDelegate)];
//        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return proxy;
//}
//
//- (void)beginObserveDidSelectedRowSignal
//{
//    bingoWeakify(self);
//    RACSignal *signal =
//    [[[self.rac_delegateProxy
//     signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)]
//     reduceEach:^id(UITableView *t,NSIndexPath *indexPath){
//         return indexPath;
//     }]
//     takeUntil:self.rac_willDeallocSignal];
//    
//    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
//    self.delegate = (id)self.rac_delegateProxy;
//
//    [signal subscribeNext:^(NSIndexPath *x) {
//        bingoStrongify(self);
//        if (self.deselectRowAutomatic) {
//            if ( [x isKindOfClass:[NSIndexPath class]]) {
//                [self deselectRowAtIndexPath:x animated:YES];
//            }
//        }
//    }];
//}

@end
