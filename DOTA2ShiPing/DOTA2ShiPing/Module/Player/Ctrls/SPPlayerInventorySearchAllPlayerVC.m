//
//  SPPlayerInventorySearchAllPlayerVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/13.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventorySearchAllPlayerVC.h"
#import "SPMacro.h"
#import <ReactiveCocoa.h>
#import <UIScrollView+EmptyDataSet.h>

@interface SPPlayerInventorySearchAllPlayerVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@end

@implementation SPPlayerInventorySearchAllPlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    spweakify(self);
    [RACObserve(self.view, hidden)
     subscribeNext:^(id x) {
         spstrongify(self);
         if ([x boolValue]) {
             self.view.hidden = NO;
         }
     }];
    
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
}

#pragma mark - UISearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",searchController.searchBar.text);
}

#pragma mark - UITableView


@end
