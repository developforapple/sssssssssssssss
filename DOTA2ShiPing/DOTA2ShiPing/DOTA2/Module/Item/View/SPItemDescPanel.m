//
//  SPItemDescPanel.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/5.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemDescPanel.h"
#import "SPItemSharedData.h"
#import "Chameleon.h"
#import "SPDataManager.h"

@import WebKit;
@import ReactiveObjC;

@interface SPItemDescPanel ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation SPItemDescPanel

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Device_Width - self.layoutMargins.left - self.layoutMargins.right, 200)];
        _webView.navigationDelegate = self;
        if (iOS10) {
            _webView.configuration.dataDetectorTypes = WKDataDetectorTypeNone;
        }
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _webView;
}

- (void)setItemData:(SPItemSharedData *)itemData
{
    _itemData = itemData;
    [self update];
}

- (void)update
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    
    
    UIColor *color = FlatGray;
    
    // styles
    NSArray *styles = self.itemData.styles;
    if (styles.count != 0) {
        
        NSDictionary *normalAttributes = @{NSForegroundColorAttributeName:color};
        NSDictionary *redAttributes = @{NSForegroundColorAttributeName:color};
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"款式：" attributes:normalAttributes];
        for (SPItemStyle *aStyle in styles) {
            NSString *text;
            if (!aStyle.name) {
                text = [NSString stringWithFormat:@"\n - 款式：%@",aStyle.index];
            }else{
                NSString *name_loc = SPLOCALNONIL(aStyle.name);
                NSString *title = [NSString stringWithFormat:@"dota_item_%@",aStyle.name];
                NSString *title_loc = SPLOCAL(title, nil);
                if (title_loc.length > 0) {
                    text = [NSString stringWithFormat:@"\n - %@：%@",title_loc,name_loc];
                }else{
                    text = [NSString stringWithFormat:@"\n - %@",name_loc];
                }
            }
            
            SPItemStyleUnlock *unlock = aStyle.unlock;
            if (unlock) {
                text = [text stringByAppendingString:@"（需要解锁）"];
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:redAttributes]];
            }else{
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:normalAttributes]];
            }
        }
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
        
        [content appendAttributedString:string];
    }
    
    if (self.itemData.playerItem) {
        // 是否有宝石
        
        NSString *base = @"<meta name='viewport' content ='initial-scale = 1.0'/> "
        "<style > span{color:rgb(149,165,166);font-size:14px} </style>"
        "";
        
        NSMutableString *playerItemDesc = [NSMutableString stringWithString:base];
        for (SPPlayerInventoryItemDesc *aDesc in self.itemData.playerItem.descriptions) {
            if ([aDesc.type isEqualToString:@"html"] && 
                [aDesc.value containsString:@"<div"]) {
                [playerItemDesc appendString:aDesc.value];
            }
        }
        if (playerItemDesc.length > 0) {
            
            NSString *result = [playerItemDesc stringByReplacingRegex:@"rgb\\(.*?\\)" options:kNilOptions withString:@"rgb(149,165,166)"];
            result = [result stringByReplacingRegex:@"margin:(.*?)px" options:kNilOptions withString:@"margin:0px"];
//            result = [result stringByReplacingRegex:@"font-size:(.*?)px" options:kNilOptions withString:@"font-size:14px"];
            [self.webView loadHTMLString:result baseURL:nil];
            ygweakify(self);
            [RACObserve(self.webView.scrollView, contentSize)
             subscribeNext:^(NSValue *x) {
                 ygstrongify(self);
                 [self showWebView:x.CGSizeValue.height];
             }];
            
//            // 替换带background-image的div标签为img标签
//            NSString *regex = @"(.*)(<div)(.*?)(background-image: url\\()(http.*?g)(\\)\\\".*?</div>)(.*)";
//            NSString *result = [playerItemDesc stringByReplacingRegex:regex options:kNilOptions withString:@"$1<img$3\"src='$5'></img>$7"];
//
//            // 替换所有的颜色为默认颜色
//            result = [result stringByReplacingRegex:@"rgb\\(.*?\\)" options:kNilOptions withString:@"rgb(149,165,166)"];
        }
    }
    
    // desc
    {
        NSError *error;
        NSString *desc = SPLOCALNONIL(self.itemData.item.item_description);
        NSData *descData = [desc dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithData:descData?:[NSData data] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
        [string setAttributes:@{NSForegroundColorAttributeName:color,
                                NSFontAttributeName:[UIFont systemFontOfSize:14]}
                        range:NSMakeRange(0, string.length)];
        
        [content appendAttributedString:string];
    }
    
    NSMutableParagraphStyle *p = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    p.lineSpacing = 4.f;
    [content addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0, content.length)];
    
    self.descLabel.attributedText = content;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{


}

- (void)showWebView:(CGFloat)height
{
    if (!self.webView.superview) {
        [self.webViewContainer addSubview:self.webView];
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.webViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.webView}]];
        [self.webViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.webView}]];
    }
    
    self.webViewHeightConstraint.constant = height;
    [self.superview layoutIfNeeded];
}

@end
