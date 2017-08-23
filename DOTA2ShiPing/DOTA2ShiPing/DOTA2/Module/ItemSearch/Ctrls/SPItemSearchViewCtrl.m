//
//  SPItemSearchViewCtrl.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/23.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSearchViewCtrl.h"
#import "SPItemSearchDelegate.h"
#import "SPItemSearchOptionViewCtrl.h"

@interface SPItemSearchViewCtrl ()<UISearchResultsUpdating>
@property (weak, readwrite, nonatomic) UISearchController *searchCtrl;
@property (weak, nonatomic) id<SPItemSearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *optionContainer;
@property (strong, nonatomic) SPItemSearchOptionViewCtrl *optionViewCtrl;

@property (strong, nonatomic) SPItemSearchOption *option;

@end

@implementation SPItemSearchViewCtrl

+ (SPItemSearchViewCtrl *)showFrom:(UIViewController *)from
                              kind:(SPItemSearchKind)kind
                          delegate:(id<SPItemSearchDelegate>)delegate
{
    return [self showFrom:from kind:kind delegate:delegate setup:nil];
}

+ (SPItemSearchViewCtrl *)showFrom:(UIViewController *)from
                              kind:(SPItemSearchKind)kind
                          delegate:(id<SPItemSearchDelegate>)delegate
                             setup:(void(^)(UISearchController *))block
{
    if (!from || !delegate) return nil;
    
    SPItemSearchViewCtrl *resutVC = [SPItemSearchViewCtrl instanceFromStoryboard];
    resutVC.option = [[SPItemSearchOption alloc] initWithKinds:kind];
    resutVC.delegate = delegate;
    
    UISearchController *vc = [[UISearchController alloc] initWithSearchResultsController:resutVC];
    resutVC.searchCtrl = vc;
    vc.searchResultsUpdater = resutVC;
    vc.searchBar.placeholder = @"搜索关键词：名称/品质/英雄";
    vc.searchBar.translucent = YES;
    [vc.searchBar setBackgroundImage:nil];
    vc.searchBar.barTintColor = kRedColor;
    vc.searchBar.searchBarStyle = UISearchBarStyleProminent;
    vc.dimsBackgroundDuringPresentation = NO;
    vc.hidesNavigationBarDuringPresentation = NO;
    
    if (block) {
        block(vc);
    }
    
    [from presentViewController:vc animated:YES completion:nil];
    return resutVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *text = searchController.searchBar.text;
    [self.optionViewCtrl updateKeywords:text];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SPItemSearchOptionViewCtrlSegueID"]) {
        self.optionViewCtrl = segue.destinationViewController;
        self.optionViewCtrl.option = self.option;
        self.optionViewCtrl.delegate = self.delegate;
    }
}

@end
