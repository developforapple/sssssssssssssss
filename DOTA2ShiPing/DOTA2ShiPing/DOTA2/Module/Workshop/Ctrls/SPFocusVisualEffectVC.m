//
//  SPFocusVisualEffectVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPFocusVisualEffectVC.h"
#import <YYCategories.h>

NSTimeInterval const kSPFocusAnimationDurtaion = .3f;

@interface SPFocusVisualEffectVC ()

@property (strong, nonatomic) UIImageView *imageView;

- (UIVisualEffectView *)effectView;

@property (strong, nonatomic) UIWindow *curWindow;
@property (weak, nonatomic) UIWindow *preWindow;

@end

@implementation SPFocusVisualEffectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.effectView.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.cornerRadius = 16.f;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.effectView.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIVisualEffectView *)effectView
{
    return (UIVisualEffectView *)[super view];
}

- (void)showFocusView:(__weak UIView *)view
           completion:(void(^)(SPFocusVisualEffectVC *focusVC,UIView *focusView))completion
{
    self.preWindow = view.window;
    self.imageView.image = [view snapshotImage];
    self.imageView.frame = [view convertRect:view.bounds toView:view.window];
    
    self.curWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.curWindow.windowLevel = UIWindowLevelStatusBar;
    self.curWindow.rootViewController = self;
    self.curWindow.alpha = 0.f;
    [self.curWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:kSPFocusAnimationDurtaion animations:^{
        self.curWindow.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (completion) completion(self,self.imageView);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:kSPFocusAnimationDurtaion animations:^{
        self.curWindow.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        self.curWindow.rootViewController = nil;
        self.curWindow = nil;
        
        [self.preWindow makeKeyAndVisible];
    }];
}

- (void)dealloc
{
    NSLog(@"%@释放",NSStringFromClass(self.class));
}

@end
