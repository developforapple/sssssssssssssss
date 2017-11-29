//
//  SPSettingAboutVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/22.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSettingAboutVC.h"

@interface SPSettingAboutVC ()
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SPSettingAboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.versionLabel.text = [NSString stringWithFormat:@"v%@ build %@",AppVersion,AppBuildVersion];
}

- (IBAction)steam:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://store.steampowered.com"];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication]openURL:URL];
    }
}

- (IBAction)qq:(id)sender
{
    if (![self joinGroup:@"4625939" key:@"d38f67801b6fc7896973735172fadaea5e31ac1e0275a1e17ce4b3e2410fbad6"]) {
        
        [UIView animateWithDuration:.2f animations:^{
            self.QRCodeView.alpha = 1.f;
        }];
    }
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key
{
    // QQ 好友
//    NSString *urlStr = @"mqqwpa://im/chat?chat_type=wpa&uin=77936804&key=d38f67801b6fc7896973735172fadaea5e31ac1e0275a1e17ce4b3e2410fbad6&version=1&src_type=internal&source=external";
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }else return NO;
}

@end
