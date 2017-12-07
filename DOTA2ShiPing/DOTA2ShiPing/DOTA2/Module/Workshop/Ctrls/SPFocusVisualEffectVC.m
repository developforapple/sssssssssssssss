//
//  SPFocusVisualEffectVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPFocusVisualEffectVC.h"

NSTimeInterval const kSPFocusAnimationDurtaion = .25f;

@interface SPFocusVisualEffectVC ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIWindow *curWindow;
@property (weak, nonatomic) UIWindow *preWindow;

@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGRect imageFrame;
@property (copy, nonatomic) void(^displayCompletion)(SPFocusVisualEffectVC *focusVC,UIView *focusView);

@end

@implementation SPFocusVisualEffectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backBtn.enabled = NO;
    self.effectView.effect = nil;
    self.imageView.frame = self.imageFrame;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:kSPFocusAnimationDurtaion animations:^{
        self.imageView.image = self.image;
        self.imageView.cornerRadius_ = 16;
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    } completion:^(BOOL finished) {
        if (self.displayCompletion) {
            self.displayCompletion(self, self.imageView);
        }
        self.backBtn.enabled = YES;
    }];
}

- (void)showFocusView:(__weak UIView *)view
           completion:(void(^)(SPFocusVisualEffectVC *focusVC,UIView *focusView))completion
{
    self.preWindow = view.window;
    self.image = [view snapshotImage];
    self.imageFrame = [view convertRect:view.bounds toView:view.window];
    self.displayCompletion = completion;
    
    self.curWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.curWindow.windowLevel = UIWindowLevelStatusBar;
    self.curWindow.rootViewController = self;
    self.curWindow.alpha = 1.f;
    [self.curWindow makeKeyAndVisible];
}

- (IBAction)dismiss:(id)sender
{
    [UIView animateWithDuration:kSPFocusAnimationDurtaion animations:^{
        
        self.effectView.effect = nil;
        self.imageView.cornerRadius_ = 0;
        
    } completion:^(BOOL finished) {
        
        ygweakify(self);
        [self.imageView setHidden:YES animated:YES completion:^{
            
            ygstrongify(self);
            [self.view removeFromSuperview];
            self.curWindow.rootViewController = nil;
            self.curWindow = nil;
            
            [self.preWindow makeKeyAndVisible];
        
        }];
    }];
}

- (void)dismiss
{
    [self dismiss:nil];
}

@end
