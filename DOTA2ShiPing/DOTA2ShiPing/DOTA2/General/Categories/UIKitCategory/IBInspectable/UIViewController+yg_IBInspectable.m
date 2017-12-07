//
//  UIViewController+yg_IBInspectable.m
//  Golf
//
//  Created by bo wang on 2017/3/16.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "UIViewController+yg_IBInspectable.h"
#import "UIViewController+yg_StatusBar.h"
#import "JZNavigationExtension.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UIScrollView+yg_IBInspectable.h"

#pragma mark - UINavigationController
static const void *nextAppearIsPushKey = &nextAppearIsPushKey;

@interface UINavigationController (POP_PUSH)
@property (assign, nonatomic) BOOL nextAppearIsPush;
@end

@implementation UINavigationController (POP_PUSH)

- (void)setNextAppearIsPush:(BOOL)nextAppearIsPush
{
    objc_setAssociatedObject(self, nextAppearIsPushKey, @(nextAppearIsPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nextAppearIsPush
{
    return [objc_getAssociatedObject(self, nextAppearIsPushKey) boolValue];
}
@end

@implementation UIViewController (yg_IBInspectable)

static const void *interactivePopEnabledKey = &interactivePopEnabledKey;
static const void *naviBarTranslucentKey    = &naviBarTranslucentKey;
static const void *naviBarBlackStyleKey     = &naviBarBlackStyleKey;
static const void *naviBarLineHiddenKey     = &naviBarLineHiddenKey;
static const void *naviBarLineColorKey      = &naviBarLineColorKey;
static const void *naviBarTextColorKey      = &naviBarTextColorKey;
static const void *naviBarShadowHiddenKey   = &naviBarShadowHiddenKey;
static const void *IQKeyboardEnabledKey     = &IQKeyboardEnabledKey;

static BOOL kDefaultInteractivePopEnabled = YES;
static BOOL kDefaultNaviBarTranslucent = YES;
static BOOL kDefaultNavigationBarBlackStyle = NO;
static BOOL kDefaultNaviBarLineHidden = YES;
static UIColor *kDefaultNaviBarLineColor;
static UIColor *kDefaultNaviBarTextColor;
static BOOL kDefaultNaviBarShadowHidden = YES;
static UIColor *kDefaultNaviBarTintColor;

static NSMutableSet<Class> *kIgnoredViewControllerClasses;

#pragma mark Ignore List
+ (void)yg_setIgnored:(BOOL)ignored
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kIgnoredViewControllerClasses = [NSMutableSet set];
    });
    if (ignored) {
        [kIgnoredViewControllerClasses addObject:[self class]];
    }else{
        [kIgnoredViewControllerClasses removeObject:[self class]];
    }
}

+ (BOOL)yg_isIgnored
{
    return [kIgnoredViewControllerClasses containsObject:[self class]];
}

- (BOOL)yg_isIgnored
{
    return [[self class] yg_isIgnored] || [[[self parentViewController] class] yg_isIgnored];
}

- (BOOL)yg_isSystemController
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [NSBundle mainBundle]==bundle;
}

#pragma mark Lift Cycle

+ (BOOL)swizzleInstanceSelector:(SEL)originalSel withNewSelector:(SEL)newSel
{
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    IMP originalIMP = class_getMethodImplementation(self, originalSel);
    class_addMethod(self,
                    originalSel,
                    originalIMP,
                    method_getTypeEncoding(originalMethod));
    IMP newIMP = class_getMethodImplementation(self, newSel);
    class_addMethod(self,
                    newSel,
                    newIMP,
                    method_getTypeEncoding(newMethod));
    Method originalMethod2 = class_getInstanceMethod(self, originalSel);
    Method newMethod2 = class_getInstanceMethod(self, newSel);
    method_exchangeImplementations(originalMethod2,
                                   newMethod2);
    return YES;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDefaultNaviBarLineColor = RGBColor(229, 229, 229, 0.8);
        kDefaultNaviBarTextColor = kTextColor;
        
        SEL oldViewWillAppearSel = @selector(viewWillAppear:);
        SEL newViewWillAppearSel = @selector(yg_viewWillAppear:);
        [self swizzleInstanceSelector:oldViewWillAppearSel withNewSelector:newViewWillAppearSel];
        
        SEL oldViewWillDisappearSel = @selector(viewWillDisappear:);
        SEL newViewWillDisappearSel = @selector(yg_viewWillDisappear:);
        [self swizzleInstanceSelector:oldViewWillDisappearSel withNewSelector:newViewWillDisappearSel];
        
        SEL oldViewDidAppearSel = @selector(viewDidAppear:);
        SEL newViewDidAppearSel = @selector(yg_viewDidAppear:);
        [self swizzleInstanceSelector:oldViewDidAppearSel withNewSelector:newViewDidAppearSel];
        
        SEL oldViewDidLoadSel = @selector(viewDidLoad);
        SEL newViewDidLoadSel = @selector(yg_viewDidLoad);
        [self swizzleInstanceSelector:oldViewDidLoadSel withNewSelector:newViewDidLoadSel];
    });
}

- (void)yg_viewDidLoad
{
    [self yg_viewDidLoad];
    
    if ([self yg_isIgnored]) return;
    
    [self _setupJz];
    
    // 取消默认的手势返回，使用JZ的全屏手势返回
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self interactivePopGestureRecognizer].enabled = NO;
    }
    
    if (self.navigationController &&
        self.parentViewController == self.navigationController) {
        // 使用自定义的返回按钮
        [self.navigationItem setHidesBackButton:YES];  //不显示默认的返回按钮，采用leftBarButtonItem作为返回按钮
        [self.navigationController.navigationBar.backItem setHidesBackButton:YES];  //解决使用手势返回中途取消手势时，导航栏出现一个默认返回按钮的问题。
        [self.navigationItem.backBarButtonItem setTitle:@""];  //隐藏默认返回按钮的标题。
    }
    
    [self updateIQKeyboardEnabled];
}

- (void)yg_viewWillAppear:(BOOL)animated
{
    [self yg_viewWillAppear:animated];
    
    if ([self yg_isIgnored]) return;
    
    if (self.navigationController &&
        self.parentViewController == self.navigationController &&
        self.navigationController.topViewController == self) {
        
        if (self.navigationController.nextAppearIsPush) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                // 这里为什么要禁用？
                // 发现一个bug，上一个界面A不要手势返回，push的下一个界面B有手势返回时，B界面的手势返回将不起作用。此时view上所有操作发生错乱。
                // 原因是这种情况下，在B界面的手势开始时，导航控制器会将 B 移出栈，将 A 加入到视图层级里面，此时将会调用A界面的 viewWillAppear 方法。在这个方法内[self updateInteractivePop] 会因为A不支持手势返回，而将B界面正在进行中的手势给取消掉。
                // 通常手势被取消，导航控制器会将 B 重新加入到栈里面来。但是此种条件下，导航控制器没有将B界面重新加入到栈里面来。此时navigationItem是A的，但是view是B的。造成界面错乱
                
                //        [self updateInteractivePop];
                
                [self updateNaviBarTranslucent];
                [self updateNaviBarLine];
                [self updateNaviBarTextColor];
                [self updateNaviBarShadow];
                [self updateNaviBarStyle]; //不更新barStyle
            } completion:^(BOOL finished) {}];
            
            [self _updateJz];
            [self updateStatusBarAppearIfNeed];
        }
    }

    [self updateIQKeyboardEnabled];
}

- (void)yg_viewDidAppear:(BOOL)animated
{
    [self yg_viewDidAppear:animated];
    
    if ([self yg_isIgnored]) return;
    
    if (self.navigationController &&
        self.parentViewController == self.navigationController &&
        self.navigationController.topViewController == self) {
//        SPLog(@"viewDidAppear");
        
        if (![self.navigationController nextAppearIsPush]) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self updateInteractivePop];
                [self updateNaviBarTranslucent];
                [self updateNaviBarLine];
                [self updateNaviBarTextColor];
                [self updateNaviBarShadow];
                [self updateNaviBarStyle];
            } completion:^(BOOL finished) {}];
            
            [self updateStatusBarAppearIfNeed];
        }
    }
    
    // 设置TabBar的默认样式
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBar *tabbar = [(UITabBarController *)self tabBar];
        tabbar.lineViewHidden_ = NO;
        tabbar.lineViewColor_ = kDefaultNaviBarLineColor;
        //        tabbar.barShadowHidden_ = YES;
    }
    
    [self _updateJz];
    [self updateIQKeyboardEnabled];
}

- (void)yg_viewWillDisappear:(BOOL)animated
{
    [self yg_viewWillDisappear:animated];
    if ([self yg_isIgnored]) return;
    
    if (self.navigationController &&
        self.parentViewController == self.navigationController) {
        
        BOOL isPush = [self.navigationController.viewControllers containsObject:self];
//        SPLog(@"%@",isPush?@"PUSH":@"POP");
        self.navigationController.nextAppearIsPush = isPush;
    }
}

#pragma mark  setup
- (void)_setupJz
{
    if (!self.navigationController || self.parentViewController != self.navigationController){
        return;
    }
    
    // 设置一些默认值
    UIColor *jz_navigationBarTintColor = objc_getAssociatedObject(self, @selector(jz_navigationBarTintColor));
    if (!jz_navigationBarTintColor) {
        self.jz_navigationBarTintColor = kDefaultNaviBarTintColor;
    }
    
    id jz_wantsNavigationBarVisibleObject = objc_getAssociatedObject(self, @selector(jz_wantsNavigationBarVisible));
    if (!jz_wantsNavigationBarVisibleObject) {
        self.jz_wantsNavigationBarVisible = YES;
    }
    
    id jz_navigationBarBackgroundAlpha = objc_getAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha));
    if (!jz_navigationBarBackgroundAlpha) {
        self.jz_navigationBarBackgroundAlpha = 1;
        
        // 解决bug
        [self.navigationController.navigationBar setYg_background_alpha:1];
    }
}

- (void)_updateJz
{
    if (!self.navigationController || self.parentViewController != self.navigationController) return;
    
    UIColor *jz_navigationBarTintColor = objc_getAssociatedObject(self, @selector(jz_navigationBarTintColor));
    if (jz_navigationBarTintColor) {
        self.jz_navigationBarTintColor = jz_navigationBarTintColor;
    }
    id jz_wantsNavigationBarVisibleObject = objc_getAssociatedObject(self, @selector(jz_wantsNavigationBarVisible));
    if (jz_wantsNavigationBarVisibleObject) {
        self.jz_wantsNavigationBarVisible = [jz_wantsNavigationBarVisibleObject boolValue];
    }
    id jz_navigationBarBackgroundAlpha = objc_getAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha));
    if (jz_navigationBarBackgroundAlpha) {
        self.jz_navigationBarBackgroundAlpha = [jz_navigationBarBackgroundAlpha doubleValue];
        
        // 解决bug
        [self.navigationController.navigationBar setYg_background_alpha:[jz_navigationBarBackgroundAlpha doubleValue]];
    }
}

#pragma mark  Default
+ (void)setDefaultInteractivePopEnabled:(BOOL)enabled
{
    kDefaultInteractivePopEnabled = enabled;
}

+ (void)setDefaultNavigationBarTranslucent:(BOOL)translucent
{
    kDefaultNaviBarTranslucent = translucent;
}

+ (void)setDefaultNavigationBarBlackStyle:(BOOL)black
{
    kDefaultNavigationBarBlackStyle = black;
}

+ (void)setDefaultNavigationBarLineHidden:(BOOL)hidden
{
    kDefaultNaviBarLineHidden = hidden;
}

+ (void)setDefaultNavigationBarLineColor:(UIColor *)color
{
    kDefaultNaviBarLineColor = color;
}

+ (void)setDefaultNavigationBarShadowHidden:(BOOL)hidden
{
    kDefaultNaviBarShadowHidden = hidden;
}

+ (void)setDefaultNavigationBarTintColor:(UIColor *)color
{
    kDefaultNaviBarTintColor = color;
}

+ (void)setDefaultNavigationBarTextColor:(UIColor *)color
{
    kDefaultNaviBarTextColor = color;
}

#pragma mark interactivePopEnabled_
- (BOOL)interactivePopEnabled_
{
    NSNumber *enable = objc_getAssociatedObject(self, interactivePopEnabledKey);
    if (enable) {
        return enable.boolValue;
    }
    return kDefaultInteractivePopEnabled;
}

- (void)setInteractivePopEnabled_:(BOOL)interactivePopEnabled_
{
    objc_setAssociatedObject(self, interactivePopEnabledKey, @(interactivePopEnabled_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateInteractivePop];
}

- (void)updateInteractivePop
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.jz_fullScreenInteractivePopGestureEnabled = self.interactivePopEnabled_;
    }
}

#pragma mark naviBarTranslucent_
- (BOOL)naviBarTranslucent_
{
    NSNumber *translucent = objc_getAssociatedObject(self, naviBarTranslucentKey);
    if (translucent) {
        return [translucent boolValue];
    }
    return kDefaultNaviBarTranslucent;
}

- (void)setNaviBarTranslucent_:(BOOL)naviBarTranslucent_
{
    objc_setAssociatedObject(self, naviBarTranslucentKey, @(naviBarTranslucent_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarTranslucent];
}

- (void)updateNaviBarTranslucent
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.navigationBar.translucent = self.naviBarTranslucent_;
    }
}

#pragma mark - naviBarStyle

- (BOOL)naviBarBlackStyle_
{
    NSNumber *style = objc_getAssociatedObject(self, naviBarBlackStyleKey);
    if (style) {
        return [style boolValue];
    }
    return kDefaultNavigationBarBlackStyle;
}

- (void)setNaviBarBlackStyle_:(BOOL)naviBarBlackStyle_
{
    objc_setAssociatedObject(self, naviBarBlackStyleKey, @(naviBarBlackStyle_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarStyle];
}

- (void)updateNaviBarStyle
{
    if (self.navigationController && self.parentViewController == self.navigationController) {
        self.navigationController.navigationBar.barStyle = self.naviBarBlackStyle_?UIBarStyleBlack:UIBarStyleDefault;
    }
}

#pragma mark naviBarLineHidden_
- (BOOL)_naviBarLineHiddenIsSet
{
    return nil!=objc_getAssociatedObject(self, naviBarLineHiddenKey);
}

- (BOOL)naviBarLineHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, naviBarLineHiddenKey);
    if (hidden) {
        return hidden.boolValue;
    }
    return kDefaultNaviBarLineHidden;
}

- (void)setNaviBarLineHidden_:(BOOL)naviBarLineHidden_
{
    objc_setAssociatedObject(self, naviBarLineHiddenKey, @(naviBarLineHidden_), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateNaviBarLine];
}

- (void)updateNaviBarLine
{
    if (self.navigationController && self.parentViewController==self.navigationController) {
        self.navigationController.navigationBar.lineViewHidden_ = self.naviBarLineHidden_;
        self.navigationController.navigationBar.lineViewColor_ = self.naviBarLineColor_;
    }
}

#pragma mark  naviBarLineColor_
- (UIColor *)naviBarLineColor_
{
    return objc_getAssociatedObject(self, naviBarLineColorKey) ? : kDefaultNaviBarLineColor;
}

- (void)setNaviBarLineColor_:(UIColor *)naviBarLineColor_
{
    objc_setAssociatedObject(self, naviBarLineColorKey, naviBarLineColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark naviBarTextColor_
- (BOOL)_naviBarTextColorIsSet
{
    return nil!=objc_getAssociatedObject(self, naviBarTextColorKey);
}

- (UIColor *)naviBarTextColor_
{
    return objc_getAssociatedObject(self, naviBarTextColorKey) ? : kDefaultNaviBarTextColor;
}

- (void)setNaviBarTextColor_:(UIColor *)naviBarTextColor_
{
    objc_setAssociatedObject(self, naviBarTextColorKey, naviBarTextColor_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateNaviBarTextColor
{
    if (self.navigationController && self.parentViewController == self.navigationController) {
        UIColor *color = self.naviBarTextColor_;
        NSDictionary *titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:titleTextAttributes];
        attributes[NSForegroundColorAttributeName] = color;
        self.navigationController.navigationBar.titleTextAttributes = attributes;
        self.navigationController.navigationBar.tintColor = color;
        
        if ([self _naviBarTextColorIsSet]) {
            [[self.navigationItem leftBarButtonItems] enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *titleTextAttributes1 = [obj titleTextAttributesForState:UIControlStateNormal];
                NSMutableDictionary *attributes1 = [NSMutableDictionary dictionaryWithDictionary:titleTextAttributes1];
                attributes1[NSForegroundColorAttributeName] = color;
                [obj setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
            }];
            [[self.navigationItem rightBarButtonItems] enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *titleTextAttributes1 = [obj titleTextAttributesForState:UIControlStateNormal];
                NSMutableDictionary *attributes1 = [NSMutableDictionary dictionaryWithDictionary:titleTextAttributes1];
                attributes1[NSForegroundColorAttributeName] = color;
                [obj setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
            }];
        }
    }
}

#pragma mark naviBarShadowHidden_
- (BOOL)_naviBarShadowHiddenIsSet
{
    return nil!=objc_getAssociatedObject(self, naviBarShadowHiddenKey);
}

- (BOOL)naviBarShadowHidden_
{
    NSNumber *hidden = objc_getAssociatedObject(self, naviBarShadowHiddenKey);
    if (hidden) {
        return hidden.boolValue;
    }
    return kDefaultNaviBarShadowHidden;
}

- (void)setNaviBarShadowHidden_:(BOOL)naviBarShadowHidden_
{
    objc_setAssociatedObject(self, naviBarShadowHiddenKey, @(naviBarShadowHidden_), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self updateNaviBarShadow];
}

- (void)updateNaviBarShadow
{
    if (self.navigationController && self.parentViewController == self.navigationController) {
        if (!self.jz_wantsNavigationBarVisible || self.jz_isNavigationBarBackgroundHidden) {
            // 默认导航栏不显示或者背景为透明时不显示阴影
            return;
        }
        self.navigationController.navigationBar.barShadowHidden_ = self.naviBarShadowHidden_;
    }
}

#pragma mark IQKeybaord
- (void)setIQKeyboardEnabled:(BOOL)IQKeyboardEnabled
{
    objc_setAssociatedObject(self, IQKeyboardEnabledKey, @(IQKeyboardEnabled), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self updateIQKeyboardEnabled];
}

- (BOOL)IQKeyboardEnabled
{
    NSNumber *enabled = objc_getAssociatedObject(self, IQKeyboardEnabledKey);
    if (enabled) {
        return [enabled boolValue];
    }
    return YES;
}

- (void)updateIQKeyboardEnabled
{
    if (self.navigationController && self.parentViewController == self.navigationController) {
        BOOL enabled = self.IQKeyboardEnabled;
        [[IQKeyboardManager sharedManager] setEnable:enabled];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:enabled];
    }
}

@end
