//
//  SPWebHelper.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/18.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWebHelper.h"
#import "DZNWebViewController.h"
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@implementation SPWebHelper

+ (void)openURL:(NSURL *)URL from:(UIViewController *)viewController
{
    if (!URL || !viewController) return;
    
    static NSString *k = @".SPOpenURLAlertMessage";
    BOOL willAlert = ![[NSUserDefaults standardUserDefaults] boolForKey:k];
    
    Class safari = NSClassFromString(@"SFSafariViewController");
    if (safari) {
        void (^open)(void) = ^{
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:URL entersReaderIfAvailable:YES];
            [viewController presentViewController:vc animated:YES completion:nil];
        };
        if (willAlert) {
            NSString *message = [NSString stringWithFormat:@"您即将使用Safari浏览器在应用中打开目标网址。现在，您可以安全的进行登录。\n\n%@",URL.absoluteString];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"安全提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                open();
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k];
            }]];
            [viewController presentViewController:alert animated:YES completion:nil];
        }else{
            open();
        }
    }else{
        void (^open)(void) = ^{
            DZNWebViewController *vc = [[DZNWebViewController alloc] initWithURL:URL];
            [viewController.navigationController pushViewController:vc animated:YES];
        };
        if (willAlert) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"建议更新至iOS9" message:@"在iOS9及以上系统，我们将使用Safari浏览器在应用内打开目标网址。您可以安全的进行登录，登录状态不会丢失。推荐使用。" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                open();
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:k];
            }]];
            [viewController presentViewController:alert animated:YES completion:nil];
        }else{
            open();
        }
    }
}

@end
