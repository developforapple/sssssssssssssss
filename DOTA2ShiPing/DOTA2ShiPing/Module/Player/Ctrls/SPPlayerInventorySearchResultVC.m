//
//  SPPlayerInventorySearchResultVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventorySearchResultVC.h"
#import "SPMacro.h"
#import "SPItemListContainer.h"
#import "SPInventoryFilter.h"
#import <ReactiveCocoa.h>

@interface SPPlayerInventorySearchResultVC ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) SPItemListContainer *container;
@end

@implementation SPPlayerInventorySearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    self.container = [SPItemListContainer instanceFromStoryboard];
    self.container.mode = self.mode;
    self.container.topInset = @(64.f);
    [self.container setupClearBackground];
    [self addChildViewController:self.container];
    [self.view addSubview:self.container.view];
    self.container.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.container.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.container.view}]];
    
    self.container.emptyDataNote = [[NSAttributedString alloc] initWithString:@"没有结果" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:AppBarColor}];
    
    spweakify(self);
    [RACObserve(self.view, hidden)
     subscribeNext:^(id x) {
         if ([x boolValue]) {
             spstrongify(self);
             self.view.hidden = NO;
         }
     }];
}

#pragma mark - UISearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSArray *items = [self.filter itemsWithKeywords:searchController.searchBar.text];
    self.container.items = items;
}

- (void)presentSearchController:(UISearchController *)searchController
{
}

@end
