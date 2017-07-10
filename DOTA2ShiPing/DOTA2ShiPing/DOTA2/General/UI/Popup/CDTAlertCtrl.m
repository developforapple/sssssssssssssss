//
//  CDTAlertCtrl.m
//  CDT
//
//  Created by wwwbbat on 2017/5/12.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#import "CDTAlertCtrl.h"

@interface CDTAlertCtrl ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightBtnWidthZeroConstraint;

@property (strong, nonatomic) CDTAlertDefine *content;
@property (strong, nonatomic) CDTAlertAction *leftAction;
@property (strong, nonatomic) CDTAlertAction *rightAction;

@end

@implementation CDTAlertCtrl

+ (instancetype)showContent:(CDTAlertDefine *)content
{
    CDTAlertCtrl *alert = [[CDTAlertCtrl alloc] init];
    alert.content = content;
    [alert show];
    return alert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self update];
}

- (void)update
{
    self.imageView.image = self.content.image;
    self.contentLabel.text = self.content.message;
    
    if (self.content.actions.count == 0) {
        self.leftBtn.hidden = self.rightBtn.hidden = YES;
    }else if (self.content.actions.count == 1){
        self.rightBtnWidthZeroConstraint.priority = 950;
        self.rightBtn.hidden = YES;
        self.leftAction = self.content.actions.firstObject;
        [self.leftBtn setTitle:self.leftAction.title forState:UIControlStateNormal];
    }else{
        self.leftAction = [self.content.actions firstObject];
        self.rightAction = self.content.actions[1];
        
        [self.leftBtn setTitle:self.leftAction.title forState:UIControlStateNormal];
        [self.rightBtn setTitle:self.rightAction.title forState:UIControlStateNormal];
    }
}

- (IBAction)btnAction:(__unused UIButton *)btn
{
    if (btn == self.leftBtn && self.leftAction.actionHandler) {
        self.leftAction.actionHandler();
    }else if (btn == self.rightBtn && self.rightAction.actionHandler){
        self.rightAction.actionHandler();
    }
    [self dismiss];
}


@end
