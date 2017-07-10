//
//  YGTextField.m
//  Golf
//
//  Created by bo wang on 2016/11/7.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "YGTextField.h"
#import "ReactiveObjC.h"
#import <ReactiveObjC/RACDelegateProxy.h>

@implementation YGTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    bingoWeakify(self);
    [[self rac_returnClickedSignal]
     subscribeNext:^(id x) {
         bingoStrongify(self);
         BOOL shouldReturn = self.shouldReturn?self.shouldReturn(self):YES;
         if (shouldReturn && self.returnKeyType == UIReturnKeyNext && self.next && [self.next canBecomeFirstResponder]) {
             [self.next becomeFirstResponder];
         }
     }];
}

- (BOOL)canPerformAction:(SEL)action withSender:(__unused id)sender
{
    if (!self.longPressEnabled) {
        return self.longPressEnabled;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)updatePlaceholder
{
    if (self.placeholderColor) {
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:self.placeholderColor,NSFontAttributeName:self.font}];
        self.attributedPlaceholder = placeholder;
    }else{
        self.attributedPlaceholder = nil;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self updatePlaceholder];
}

- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    bingoWeakify(self);
    [RACObserve(self, tintColor)
     subscribeNext:^(UIColor *x) {
         bingoStrongify(self);
         CGColorRef color1 = x.CGColor;
         CGColorRef color2 = self.cursorColor.CGColor;
         if (!CGColorEqualToColor(color1, color2)) {
             self.tintColor = self.cursorColor;
         }
     }];
}

#pragma mark - 

- (RACDelegateProxy *)rac_delegateProxy {
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return proxy;
}

- (RACSignal *)rac_returnClickedSignal{
    RACSignal *signal = [[self.rac_delegateProxy
                            signalForSelector:@selector(textFieldShouldReturn:)]
                          takeUntil:self.rac_willDeallocSignal];
    
    if (self.delegate != self.rac_delegateProxy) {
        self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
        self.delegate = (id)self.rac_delegateProxy;
    }
    
    return signal;
}

@end
