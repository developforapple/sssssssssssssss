//
//  SPItemOffPriceVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/8.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPItemOffPriceVC.h"
#import <WebKit/WebKit.h>

@interface SPItemOffPriceVC () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchItem;

@end

@implementation SPItemOffPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor blackColor];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.view sendSubviewToBack:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.webView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.webView}]];
    
    [self.loadIndicator startAnimating];
    self.searchItem.enabled = NO;
    
    NSString *url = @"http://event.dota2.com.cn/dota2/featured/index/?appinstall=0";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}

- (IBAction)search:(UIBarButtonItem *)item
{
    
}

#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.loadIndicator stopAnimating];
    self.searchItem.enabled = YES;
}

@end
