//
//  SPPlayerInventorySearchResultVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/10.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventorySearchResultVC.h"
#import "SPItemListContainer.h"
#import "SPInventoryFilter.h"
#import "SPPlayerInventorySearchFilterVC.h"
#import <ReactiveObjC.h>

static NSString *const kSPPlayerInventoryFilterSegueID = @"SPPlayerInventoryFilterSegueID";

@interface SPPlayerInventorySearchResultVC ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) SPItemListContainer *container;
@property (weak, nonatomic) IBOutlet UIView *filterContainer;
@property (strong, nonatomic) SPPlayerInventorySearchFilterVC *filterVC;

@end

@implementation SPPlayerInventorySearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    self.container = [SPItemListContainer instanceFromStoryboard];
    self.container.mode = self.mode;
    self.container.topInset = @(64.f);
    [self.container setupClearBackground];
    [self addChildViewController:self.container];
    [self.view addSubview:self.container.view];
    self.container.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.container.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:kNilOptions metrics:nil views:@{@"view":self.container.view}]];
    
    self.container.emptyDataNote = [[NSAttributedString alloc] initWithString:@"没有结果" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:kTextColor}];
    
    ygweakify(self);
    [RACObserve(self.view, hidden)
     subscribeNext:^(id x) {
         if ([x boolValue]) {
             ygstrongify(self);
             self.view.hidden = NO;
             
             [self setFilterVisible:YES];
         }
     }];
}

- (void)setSearchResultListVisible:(BOOL)visible
{
    [self.container.view setHidden:!visible animated:YES];
    if (visible) {
        [self setFilterVisible:NO];
    }
}

- (void)setFilterVisible:(BOOL)visible
{
    [self.filterContainer setHidden:!visible animated:YES];
    if (visible) {
        [self setSearchResultListVisible:NO];
    }
}

#pragma mark - UISearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *text = searchController.searchBar.text;
    if (self.container.view.hidden && text.length != 0) {
        [self setSearchResultListVisible:YES];
    }
    NSArray *items = [self.filter itemsWithKeywords:searchController.searchBar.text];
    self.container.items = items;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPPlayerInventoryFilterSegueID]) {
        self.filterVC = segue.destinationViewController;
        self.filterVC.filter = self.filter;
        ygweakify(self);
        [self.filterVC setWillShowFilterResult:^{
            ygstrongify(self);
            [self.searchCtrl setActive:NO];
            if (self.willShowFilteredResult) {
                self.willShowFilteredResult();
            }
        }];
    }
}

@end
