//
//  SPItemsDetailViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemsDetailViewCtrl.h"
#import "DOTA2ShiPing-Swift.h"
#import "ZLSwipeableViewSwift-Swift.h"

@interface SPItemsDetailViewCtrl2 ()
@property (weak, nonatomic) IBOutlet ZLSwipeableView *cardContainer;
@end

@implementation SPItemsDetailViewCtrl2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL ob = [self.cardContainer respondsToSelector:@selector(allowedDirection)];
    
    id object2 = [self.cardContainer performSelector:@selector(allowedDirection)];
    
    ygweakify(self);
    self.cardContainer.onlySwipeTopCard = YES;
//    self.cardContainer.allow
    self.cardContainer.didStart = ^(UIView *card, CGPoint p) {
        ygstrongify(self);
        NSLog(@"Did start swiping view at location: %@",NSStringFromCGPoint(p));
    };
    self.cardContainer.swiping = ^(UIView *card, CGPoint p0, CGPoint p1) {
        
    };
    self.cardContainer.didEnd = ^(UIView *card, CGPoint p) {
        
    };
    
    self.cardContainer.nextView = ^UIView *{
        ygstrongify(self);
        UIView *view = [[UIView alloc] initWithFrame:self.cardContainer.bounds];
        view.backgroundColor = RandomColor;
        view.layer.cornerRadius = 8.f;
        view.layer.shadowColor = view.backgroundColor.CGColor;
        view.layer.shadowRadius = 8.f;
        view.layer.shadowOpacity = 0.4f;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = Screen_Scale;
        return view;
    };
}

@end
