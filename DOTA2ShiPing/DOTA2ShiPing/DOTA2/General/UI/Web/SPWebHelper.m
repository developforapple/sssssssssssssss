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
@import SafariServices;

@implementation SPWebHelper

+ (void)openURL:(NSURL *)URL from:(UIViewController *)viewController
{
    if (!URL || !viewController) return;

    SPBP(Event_Website, [URL.host stringByAppendingPathComponent:URL.path]);
    
    if (iOS9) {
        SFSafariViewController *vc;
        if (iOS11) {
            SFSafariViewControllerConfiguration *config = [SFSafariViewControllerConfiguration new];
            config.entersReaderIfAvailable = YES;
            config.barCollapsingEnabled = YES;
            vc = [[SFSafariViewController alloc] initWithURL:URL configuration:config];
        }else{
            vc = [[SFSafariViewController alloc] initWithURL:URL entersReaderIfAvailable:YES];
        }
        if (iOS10) {
            vc.preferredBarTintColor = kBarTintColor;
        }
        if (iOS11) {
            vc.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        }
        [viewController presentViewController:vc animated:YES completion:nil];
    }else{
        DZNWebViewController *vc = [[DZNWebViewController alloc] initWithURL:URL];
        [viewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
