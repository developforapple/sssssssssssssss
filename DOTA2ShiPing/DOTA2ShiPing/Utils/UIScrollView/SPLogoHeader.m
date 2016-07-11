//
//  SPLogoHeader.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPLogoHeader.h"

@interface SPLogoHeader ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation SPLogoHeader

+ (void)setLogoHeaderInScrollView:(__kindof UIScrollView *)scrollView
{
    SPLogoHeader *header = [SPLogoHeader headerWithRefreshingBlock:nil];
    header.state = MJRefreshStateNoMoreData;
    scrollView.mj_header = header;
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSArray *subViews = scrollView.subviews;
        Class c = NSClassFromString([NSString stringWithFormat:@"UITabl%@perView",@"eViewWrap"]);
        NSUInteger index = NSNotFound;
        for (UIView *v in subViews) {
            if ([v isKindOfClass:c]) {
                index = [subViews indexOfObject:v];
                break;
            }
        }
        if (index > 1) {
            [scrollView exchangeSubviewAtIndex:0 withSubviewAtIndex:index-1];
        }
    }
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-2"]];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(96)]" options:kNilOptions metrics:nil views:@{@"view":_imageView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(96)]-20-|" options:kNilOptions metrics:nil views:@{@"view":_imageView}]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    }
}

@end
