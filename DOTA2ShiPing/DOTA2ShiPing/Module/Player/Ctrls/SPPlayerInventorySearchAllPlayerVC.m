//
//  SPPlayerInventorySearchAllPlayerVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/13.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerInventorySearchAllPlayerVC.h"
#import <ReactiveCocoa.h>

@interface SPPlayerInventorySearchAllPlayerVC ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@end

@implementation SPPlayerInventorySearchAllPlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - UISearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",searchController.searchBar.text);
}


@end
