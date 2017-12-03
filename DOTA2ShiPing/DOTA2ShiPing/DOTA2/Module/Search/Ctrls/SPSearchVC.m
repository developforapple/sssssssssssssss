//
//  SPSearchVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/17.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPSearchVC.h"

#import "SPSearchEngine.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SPItemQuery.h"
#import "SPPlayer.h"
#import "SPSearchCell.h"
#import "SPPlayerDetailInfoVC.h"
#import "DDProgressHUD.h"
#import "SPItemListVC.h"

static NSString *kSPSearchPlayerDetailSegueID = @"SPSearchPlayerDetailSegueID";

@interface SPSearchVC () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchResults;

@property (strong, nonatomic) SPSearchEngine *engine;
@end

@implementation SPSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.engine = [[SPSearchEngine alloc] initWithType:self.type];
    self.searchResults = [self.engine itemNamesSearchHistory];
    
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark -
- (void)initUI
{
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPSearchCell forIndexPath:indexPath];
    
    switch (self.type) {
        case SPSearchTypeItemName:{
            [cell configureWithText:self.searchResults[indexPath.row]];
        }   break;
        case SPSearchTypeMaxPlusPlayer:
        case SPSearchTypeDotabuffPlayer:
        case SPSearchTypeSteamCommunityPlayer:{
            SPPlayer *user = self.searchResults[indexPath.row];
            [cell configureWithUser:user];
        }   break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar endEditing:YES];
    
    switch (self.type) {
        case SPSearchTypeItemName: {
            [self showItemDetail:self.searchResults[indexPath.row]];
            break;
        }
        case SPSearchTypeMaxPlusPlayer:
        case SPSearchTypeDotabuffPlayer:
        case SPSearchTypeSteamCommunityPlayer: {
            SPPlayer *user = self.searchResults[indexPath.row];
            [self performSegueWithIdentifier:kSPSearchPlayerDetailSegueID sender:user];
            break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isDecelerating]) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - Empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"没有结果" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.searchResults.count==0;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.type == SPSearchTypeItemName) {
        NSArray *results = [self.engine searchItemNamesWithKeyward:searchText limit:20];
        if (results) {
            self.searchResults = results;
            [self.tableView reloadData];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    switch (self.type) {
        case SPSearchTypeItemName:{
            [self showItemList:searchBar.text];
        }   break;
        case SPSearchTypeMaxPlusPlayer:
        case SPSearchTypeDotabuffPlayer:
        case SPSearchTypeSteamCommunityPlayer:{
            [self showUserList:searchBar.text];
        }   break;
    }
}

#pragma mark - Segue
- (void)showItemDetail:(NSString *)name
{
    NSLog(@"饰品详情 %@",name);
    
    //TODO
}

- (void)showItemList:(NSString *)keywords
{
    SPItemQuery *query = [SPItemQuery queryWithKeywords:keywords];
    SPItemListVC *vc = [SPItemListVC instanceFromStoryboard];
    vc.query = query;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showUserList:(NSString *)keywords
{
    DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:self.view];
    ygweakify(self);
    [self.engine searchUserWithKeyword:keywords completion:^(BOOL suc, NSArray<SPPlayer *> *users) {
        ygstrongify(self);
        if (suc) {
            [HUD hideAnimated:YES];
            self.searchResults = users;
            [self.tableView reloadData];
        }else{
            [HUD showAutoHiddenHUDWithMessage:@"出错了"];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPSearchPlayerDetailSegueID]){
        SPPlayerDetailInfoVC *vc = segue.destinationViewController;
        vc.player = sender;
    }
}

@end
