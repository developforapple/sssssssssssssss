//
//  SPFeedbackViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/29.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPFeedbackViewCtrl.h"
@import IQKeyboardManager.IQTextView;
@import ReactiveObjC;
@import AVOSCloud;
@import ChameleonFramework;

typedef NS_ENUM(NSUInteger, SPFeedbackType) {
    SPFeedbackTypeBUG = 0,
    SPFeedbackTypeNormal = 1,
    SPFeedbackTypeQuestion = 2,
    SPFeedbackTypeSB = 3
};

static NSTimeInterval kLastSubmit = 0;

@interface SPFeedbackViewCtrl ()
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet IQTextView *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentControl;

@property (copy, nonatomic) NSString *contact;
@property (copy, nonatomic) NSString *content;

@end

@implementation SPFeedbackViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self rightNavButtonText:@"发送"];
    
    [self initSignal];
    
    self.typeSegmentControl.tintColor = FlatSkyBlue;
}

- (void)initSignal
{
    ygweakify(self);
    [[self.contactTextField.rac_textSignal
      map:^id (NSString *value) {
          ygstrongify(self);
          if (value.length > 100) {
              [SVProgressHUD showInfoWithStatus:@"字数太多"];
              value = [value substringToIndex:100];
              self.contactTextField.text = value;
          }
          return value;
      }]
     subscribeNext:^(id x) {
         ygstrongify(self);
         self.contact = x;
     }];
    [[self.textView.rac_textSignal
      map:^id (NSString *value) {
          ygstrongify(self);
          if (value.length > 500) {
              [SVProgressHUD showInfoWithStatus:@"字数太多"];
              value = [value substringToIndex:500];
              self.textView.text = value;
          }
          return value;
      }]
     subscribeNext:^(id x) {
         ygstrongify(self);
         self.content = x;
     }];
}

- (void)doRightNaviBarItemAction
{
    [self.view endEditing:YES];
    
    if (self.content.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入内容"];
    }else if (self.contact.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入联系方式"];
    }else{
        
        SPFeedbackType type = self.typeSegmentControl.selectedSegmentIndex;
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        if (time - kLastSubmit < 10) {
            //10秒内不可重复提交
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请%.0f秒后再试",time-kLastSubmit]];
            return;
        }
        
        [SVProgressHUD show];
        
        AVObject *object = [AVObject objectWithClassName:@"Feedback"];
        [object setObject:self.content forKey:@"Content"];
        [object setObject:self.contact forKey:@"Contact"];
        [object setObject:@(type) forKey:@"type"];
        
        RunOnGlobalQueue(^{
            
            BOOL suc = [object save];
            RunOnMainQueue(^{
                if (suc) {
                    [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
                    kLastSubmit = [[NSDate date] timeIntervalSince1970];
                    RunAfter(.2f, ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
            });
        });
    }
}



@end
