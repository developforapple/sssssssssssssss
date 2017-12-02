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
    
    Class safari = NSClassFromString(@"SFSafariViewController");
    if (safari) {
        void (^open)(void) = ^{
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:URL entersReaderIfAvailable:NO];
            if (iOS10) {
                vc.preferredBarTintColor = kBarTintColor;
            }
            [viewController presentViewController:vc animated:YES completion:nil];
        };
        open();
    }else{
        void (^open)(void) = ^{
            DZNWebViewController *vc = [[DZNWebViewController alloc] initWithURL:URL];
            [viewController.navigationController pushViewController:vc animated:YES];
        };
        open();
    }
}

@end
