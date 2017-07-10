//
//  YGBaseWebViewCtrl.m
//
//  Created by WangBo on 2017/4/7.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#import "YGBaseWebViewCtrl.h"
#import "BingoJSInterface.h"
#import "YGRefreshComponent.h"

static void *kEstimatedProgressCtx = &kEstimatedProgressCtx;
static NSString *const kEstimatedProgressKey = @"estimatedProgress";

@interface YGBaseWebViewCtrl ()<WKUIDelegate,WKNavigationDelegate>
{
    BOOL _refuseExternalHostIsSet;
}
@property (strong, readwrite, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) BingoJSInterface *jsInterface;
@end

@implementation YGBaseWebViewCtrl

+ (NSMutableArray *)internalHosts
{
    static NSMutableArray *hosts;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hosts = [NSMutableArray array];
        [hosts addObject:kAppHost];
        [hosts addObject:kAppWechatHost];
    });
    return hosts;
}

+ (void)addInternalHost:(NSString *)host
{
    [[self internalHosts] addObject:host];
}

+ (instancetype)webViewCtrlWithURL:(NSString *)URL
{
    YGBaseWebViewCtrl *vc = [[YGBaseWebViewCtrl alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.refuseExternalHost = NO;
    vc.baseUrl = URL;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    if (!_refuseExternalHostIsSet) {
        _refuseExternalHostIsSet = YES;
        self.refuseExternalHost = YES;
    }
    
    [self initWebView];
    [self initProgressView];
    
    if (self.baseUrl) {
        [self loadURL];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:self.progressView];
    self.progressLayer.bounds = self.progressView.bounds;
}

- (void)dealloc
{
    [_webView stopLoading];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)initWebView
{
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds ];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *dict = @{@"view":self.webView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:dict]];
    
    self.jsInterface = [[BingoJSInterface alloc] initWithWebView:self.webView delegate:self];
    self.jsInterface.viewController = self;
    [self.jsInterface registerAllHander];
    
    [self.webView addObserver:self forKeyPath:kEstimatedProgressKey options:NSKeyValueObservingOptionNew context:kEstimatedProgressCtx];
}

- (void)initProgressView
{
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 2)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view":self.progressView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(==4)]" options:kNilOptions metrics:nil views:views]];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(Screen_Width, 1)];
    path.lineWidth = CGRectGetHeight(self.progressView.bounds);
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.progressLayer.bounds = self.progressView.bounds;
    self.progressLayer.path = path.CGPath;
    self.progressLayer.lineWidth =  CGRectGetHeight(self.progressView.bounds);
    self.progressLayer.strokeColor = kBlueColor.CGColor;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    [self.progressView.layer addSublayer:self.progressLayer];
}

- (void)loadURL
{
    if (!self.baseUrl) return;
//#if DEBUG
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.f];
//#else
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrl]];
//#endif
    [self.webView loadRequest:request];
}

- (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    if ([self isViewLoaded]) {
        [self loadURL];
    }
}

- (void)setRefuseExternalHost:(BOOL)refuseExternalHost
{
    _refuseExternalHost = refuseExternalHost;
    _refuseExternalHostIsSet = YES;
}

- (void)setRefreshControlEnabled:(BOOL)refreshControlEnabled
{
    _refreshControlEnabled = refreshControlEnabled;
    bingoWeakify(self);
    [self.webView.scrollView refreshHeader:refreshControlEnabled footer:NO callback:^(YGRefreshType type) {
        bingoStrongify(self);
        [self.webView reload];
    }];
}

- (BOOL)supportedURL:(NSURL *)URL
{
    NSString *host = URL.host;
    BOOL support = NO;
    if (self.refuseExternalHost) {
        for (NSString *internalHost in [YGBaseWebViewCtrl internalHosts]) {
            if ([host containsString:internalHost]) {
                support = YES;
                break;
            }
        }
    }else{
        support = YES;
    }
    return support;
}

- (void)updateTitleIfNeed
{
    bingoWeakify(self);
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id data, NSError *error) {
        bingoStrongify(self);
        if ([data isKindOfClass:[NSString class]]) {
            self.navigationItem.title = data;
        }
    }];
}

- (void)doLeftNaviBarItemAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [super doLeftNaviBarItemAction];
    }
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == kEstimatedProgressCtx && [keyPath isEqualToString:kEstimatedProgressKey]) {
        [self updateProgress:self.webView.estimatedProgress];
    }
}

- (void)updateProgress:(double)progress
{
    if (progress == 1) {
        [self.progressView setHidden:YES animated:YES];
    }else{
        self.progressView.hidden = NO;
    }
    self.progressLayer.strokeEnd = progress;
}

#pragma mark -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    BOOL support = [self supportedURL:URL];
    decisionHandler(support?WKNavigationActionPolicyAllow:WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSURL *URL = navigationResponse.response.URL;
    BOOL support = [self supportedURL:URL];
    decisionHandler(support?WKNavigationResponsePolicyAllow:WKNavigationResponsePolicyCancel);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self updateTitleIfNeed];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self updateTitleIfNeed];
    [self.webView.scrollView endHeaderRefreshing];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self.webView.scrollView endHeaderRefreshing];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}

#pragma mark
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    [UIAlertController alert:message message:nil callback:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    [UIAlertController confirm:message callback:completionHandler];
}

@end





