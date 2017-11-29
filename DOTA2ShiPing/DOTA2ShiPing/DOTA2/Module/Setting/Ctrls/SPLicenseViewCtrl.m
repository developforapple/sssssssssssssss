//
//  SPLicenseViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/29.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPLicenseViewCtrl.h"

@interface SPLicenseViewCtrl ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SPLicenseViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = AppResource(@"LICENSE");
    self.textView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
