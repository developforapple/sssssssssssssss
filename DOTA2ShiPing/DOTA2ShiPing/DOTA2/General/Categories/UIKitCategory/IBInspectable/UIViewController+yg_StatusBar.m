//
//  UIViewController+yg_StatusBarAppearance.m
//  DOTA2ShiPing
//
//  Created by WangBo (developforapple@163.com) on 2017/7/20.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "UIViewController+yg_StatusBar.h"

NSString *const kYGStatusBarStyleBlackText = @"black";
NSString *const kYGStatusBarStyleLightText = @"light";
NSString *const kYGStatusBarStyleWhiteText = @"white";
NSString *const kYGStatusBarStyleAutoText = @"auto";

static BOOL _kStatusBarControlModeIsSet = NO;
static YGStatusBarControlMode kStatusBarControlMode = YGStatusBarControlModeAuto;
static BOOL _kDefaultStatusBarStyleIsSet = NO;
static UIStatusBarStyle kDefaultStatusBarStyle = UIStatusBarStyleDefault;

static const void *kStatusBarStyleKey        = &kStatusBarStyleKey;
static const void *kStatusBarStyleTextKey    = &kStatusBarStyleTextKey;
static const void *kStatusBarHiddenKey       = &kStatusBarHiddenKey;


BOOL swizzleInstanceOfSelector(Class cls, SEL originalSel, SEL newSel){
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    IMP originalIMP = class_getMethodImplementation(cls, originalSel);
    class_addMethod(cls,
                    originalSel,
                    originalIMP,
                    method_getTypeEncoding(originalMethod));
    IMP newIMP = class_getMethodImplementation(cls, newSel);
    class_addMethod(cls,
                    newSel,
                    newIMP,
                    method_getTypeEncoding(newMethod));
    Method originalMethod2 = class_getInstanceMethod(cls, originalSel);
    Method newMethod2 = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod2,
                                   newMethod2);
    return YES;
}

NO_WARNING_BEGIN(-Wundeclared-selector)
void swizzleStatusBarAppearanceMethods(Class cls){
    {
        SEL oldSel = @selector(prefersStatusBarHidden);
        SEL newsel = @selector(yg_prefersStatusBarHidden);
        swizzleInstanceOfSelector(cls, oldSel, newsel);
    }
    
    {
        SEL oldSel = @selector(childViewControllerForStatusBarHidden);
        SEL newsel = @selector(yg_childViewControllerForStatusBarHidden);
        swizzleInstanceOfSelector(cls, oldSel, newsel);
    }
    
    {
        SEL oldSel = @selector(preferredStatusBarStyle);
        SEL newsel = @selector(yg_preferredStatusBarStyle);
        swizzleInstanceOfSelector(cls, oldSel, newsel);
    }
    
    {
        SEL oldSel = @selector(childViewControllerForStatusBarStyle);
        SEL newsel = @selector(yg_childViewControllerForStatusBarStyle);
        swizzleInstanceOfSelector(cls, oldSel, newsel);
    }
}
NO_WARNING_END

@implementation UINavigationController (yg_StatusBarAppearance)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isViewControllerBasedStatusBarAppearance]) {
            swizzleStatusBarAppearanceMethods([self class]);
        }
    });
}

@end

@implementation UITabBarController (yg_StatusBarAppearance)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isViewControllerBasedStatusBarAppearance]) {
            swizzleStatusBarAppearanceMethods([self class]);
        }
    });
}
@end

@implementation UIViewController (yg_StatusBarAppearance)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([self isViewControllerBasedStatusBarAppearance]) {
            swizzleStatusBarAppearanceMethods([self class]);
        }
    });
}

+ (BOOL)isViewControllerBasedStatusBarAppearance
{
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue];
}

+ (YGStatusBarControlMode)statusBarControlMode
{
    if (!_kStatusBarControlModeIsSet) {
        if ([self isViewControllerBasedStatusBarAppearance]) {
            self.statusBarControlMode = YGStatusBarControlModeAuto;
        }else{
            self.statusBarControlMode = YGStatusBarControlModeApplication;
        }
    }
    return kStatusBarControlMode;
}

+ (void)setStatusBarControlMode:(YGStatusBarControlMode)mode
{
    switch (mode) {
        case YGStatusBarControlModeApplication:{
            NSAssert(![self isViewControllerBasedStatusBarAppearance], @"由应用控制时，需要设置info.plst中“View controller-based status bar appearance”为NO");
        }   break;
        case YGStatusBarControlModeAuto:
        case YGStatusBarControlModeViewCtrl:{
            NSAssert([self isViewControllerBasedStatusBarAppearance], @"由视图控制器控制时，需要设置info.plst中“View controller-based status bar appearance”为YES");
        }   break;
    }
    
    kStatusBarControlMode = mode;
    _kStatusBarControlModeIsSet = YES;
}

+ (UIStatusBarStyle)defaultStatusBarStyle
{
    return kDefaultStatusBarStyle;
}

+ (void)setDefaultStatusBarStyle:(UIStatusBarStyle)defaultStatusBarStyle
{
    _kDefaultStatusBarStyleIsSet = YES;
    kDefaultStatusBarStyle = defaultStatusBarStyle;
}

- (void)updateStatusBarAppearIfNeed
{
    [self updateStatusBarStyleIfNeed];
    [self updateStatusBarHiddenIfNeed];
}

- (UIStatusBarStyle)statusBarStyleForStatusBar
{
    if (![self statusBarStyleIsSet]) {
        return [UIViewController defaultStatusBarStyle];
    }
    
    UIStatusBarStyle style = UIStatusBarStyleDefault;
    switch (self.statusBarStyle_) {
        case YGStatusBarStyleBlack:
            style = UIStatusBarStyleDefault;
            break;
        case YGStatusBarStyleLight:
            style = UIStatusBarStyleLightContent;
            break;
        case YGStatusBarStyleAuto:{
            UINavigationBar *naviBar = self.navigationController.navigationBar;
            if (naviBar && naviBar.barStyle == UIBarStyleBlack) {
                style = UIStatusBarStyleLightContent;
            }else{
                style = UIStatusBarStyleDefault;
            }
        }   break;
    }
    return style;
}

- (void)updateStatusBarStyleIfNeed
{
    UIStatusBarStyle style = [self statusBarStyleForStatusBar];
    
    switch ([UIViewController statusBarControlMode]) {
        case YGStatusBarControlModeApplication:{
            [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
        }   break;
        case YGStatusBarControlModeViewCtrl:
        case YGStatusBarControlModeAuto:{
            [UIView animateWithDuration:.15 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }   break;
    }
}

- (void)updateStatusBarHiddenIfNeed
{
    BOOL hidden = self.statusBarHidden_;
    switch ([UIViewController statusBarControlMode]) {
        case YGStatusBarControlModeApplication:{
            [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
        }   break;
        case YGStatusBarControlModeViewCtrl:
        case YGStatusBarControlModeAuto:{
            [UIView animateWithDuration:.15 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }   break;
    }
}

#pragma mark View controller-based method
- (BOOL)yg_prefersStatusBarHidden
{
    //    NSLog(@"%@\t yg_prefersStatusBarHidden",NSStringFromClass([self class]));
    switch ([UIViewController statusBarControlMode]) {
        case YGStatusBarControlModeApplication:{
            return [UIApplication sharedApplication].statusBarHidden;
        }
        case YGStatusBarControlModeViewCtrl:{
            return [self yg_prefersStatusBarHidden];
        }
        case YGStatusBarControlModeAuto:{
            return self.statusBarHidden_;
        }
    }
    return [self yg_prefersStatusBarHidden];
}

- (UIViewController *)yg_childViewControllerForStatusBarHidden
{
    //    NSLog(@"%@\t yg_childViewControllerForStatusBarHidden",NSStringFromClass([self class]));
    if ([UIViewController statusBarControlMode] == YGStatusBarControlModeAuto) {
        if ([self isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)self topViewController];
        }else if ([self isKindOfClass:[UITabBarController class]]){
            return [(UITabBarController *)self selectedViewController];
        }else if ([self statusBarHiddenIsSet]){
            return nil;
        }
    }
    return [self yg_childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)yg_preferredStatusBarStyle
{
//    NSLog(@"%@\t yg_preferredStatusBarStyle",NSStringFromClass([self class]));
    switch ([UIViewController statusBarControlMode]) {
        case YGStatusBarControlModeApplication:{
            return [UIApplication sharedApplication].statusBarStyle;
        }
        case YGStatusBarControlModeViewCtrl:{
            return [self yg_preferredStatusBarStyle];
        }
        case YGStatusBarControlModeAuto:{
            return [self statusBarStyleForStatusBar];
        }
    }
    return [self yg_preferredStatusBarStyle];
}

- (UIViewController *)yg_childViewControllerForStatusBarStyle
{
//    NSLog(@"%@\t yg_childViewControllerForStatusBarStyle",NSStringFromClass([self class]));
    if ([UIViewController statusBarControlMode] == YGStatusBarControlModeAuto) {
        if ([self isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)self topViewController];
        }else if ([self isKindOfClass:[UITabBarController class]]){
            return [(UITabBarController *)self selectedViewController];
        }else if ([self statusBarStyleIsSet]){
            return nil;
        }
    }
    return [self yg_childViewControllerForStatusBarStyle];
}

#pragma mark StatusBar
- (void)setStatusBarStyle_:(int)statusBarStyle_
{
    objc_setAssociatedObject(self, kStatusBarStyleKey, @(statusBarStyle_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateStatusBarStyleIfNeed];
}

- (int)statusBarStyle_
{
    NSNumber *v = objc_getAssociatedObject(self, kStatusBarStyleKey);
    return v.intValue;
}

- (void)setStatusBarStyleText_:(NSString *)statusBarStyleText_
{
    if ([self statusBarStyleIsSet] &&
        objc_getAssociatedObject(self, kStatusBarStyleTextKey) == nil) {
        return;
    }
    
    if ([statusBarStyleText_ isEqualToString:kYGStatusBarStyleBlackText]) {
        self.statusBarStyle_ = YGStatusBarStyleBlack;
    }else if ([statusBarStyleText_ isEqualToString:kYGStatusBarStyleLightText] ||
              [statusBarStyleText_ isEqualToString:kYGStatusBarStyleWhiteText]){
        self.statusBarStyle_ = YGStatusBarStyleLight;
    }else if ([statusBarStyleText_ isEqualToString:kYGStatusBarStyleAutoText]){
        self.statusBarStyle_ = YGStatusBarStyleAuto;
    }
    objc_setAssociatedObject(self, kStatusBarStyleTextKey, statusBarStyleText_, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)statusBarStyleText_
{
    NSString *text = objc_getAssociatedObject(self, kStatusBarStyleTextKey);
    if (text) {
        return text;
    }
    
    switch (self.statusBarStyle_) {
        case YGStatusBarStyleBlack:
            return kYGStatusBarStyleBlackText;
        case YGStatusBarStyleLight:
            return kYGStatusBarStyleLightText;
        case YGStatusBarStyleAuto:
            return kYGStatusBarStyleAutoText;
    }
    return nil;
}

- (BOOL)statusBarStyleIsSet
{
    NSNumber *v = objc_getAssociatedObject(self, kStatusBarStyleKey);
    return v != nil;
}

- (void)setStatusBarHidden_:(BOOL)statusBarHidden_
{
    objc_setAssociatedObject(self, kStatusBarHiddenKey, @(statusBarHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateStatusBarHiddenIfNeed];
}

- (BOOL)statusBarHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, kStatusBarHiddenKey);
    return hidden?hidden.boolValue:NO;
}

- (BOOL)statusBarHiddenIsSet
{
    return nil != objc_getAssociatedObject(self, kStatusBarHiddenKey);
}

- (void)setStatusBarLight_:(BOOL)statusBarLight_
{
    self.statusBarStyle_ = YGStatusBarStyleLight;
}

- (BOOL)statusBarLight_
{
    return self.statusBarStyle_ == YGStatusBarStyleLight;
}

- (BOOL)statusBarLightIsSet
{
    return [self statusBarStyleIsSet];
}

@end
