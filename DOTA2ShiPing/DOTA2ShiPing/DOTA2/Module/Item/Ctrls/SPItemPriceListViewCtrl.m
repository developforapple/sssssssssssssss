//
//  SPItemPriceListViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/25.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemPriceListViewCtrl.h"
#import "SPSteamAPI.h"
#import "TFHpple.h"
#import "SPMarketItem.h"
#import "SPItemPriceCell.h"
#import "SPWebHelper.h"
#import "SPPriceChartViewCtrl.h"
#import "LCActionSheet.h"

@interface SPItemPriceListViewCtrl () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<SPMarketItem *> *list;
@end

@implementation SPItemPriceListViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setItem:(SPItem *)item
{
    _item = item;
    [self loadPriceList];
}

- (void)willPreviewItem:(SPMarketItem *)item
{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:item.name buttonTitles:@[@"历史价格变动",@"前往市场"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            SPPriceChartViewCtrl *vc = [SPPriceChartViewCtrl instanceFromStoryboard];
            vc.marketItem = item;
            vc.item = self.item;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 1){
             [SPWebHelper openURL:[NSURL URLWithString:item.href] from:self.parentViewController];
        }
    }];
    [sheet show];
}

- (TFHppleElement *)search:(TFHppleElement *)element class:(NSString *)class
{
    NSString *elementClass = [element objectForKey:@"class"];
    if ([elementClass isEqualToString:class]) {
        return element;
    }
    for (TFHppleElement *child in element.children) {
        TFHppleElement *result = [self search:child class:class];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (void)loadPriceList
{
    [[SPSteamAPI shared] fetchSteamMarketContent:self.item.name completion:^(BOOL suc, TFHpple *object, NSString *taskDesc) {
        [self.activity stopAnimating];
        if (!suc) {
            [SVProgressHUD showErrorWithStatus:(NSString *)object];
            return;
        }
        RunOnGlobalQueue(^{
            NSMutableArray *list = [NSMutableArray array];
            NSArray<TFHppleElement *> *result = [object searchWithXPathQuery:@"//a[@class='market_listing_row_link']"];
            for (TFHppleElement *a in result) {
                NSString *href = [a objectForKey:@"href"];
                
                TFHppleElement *name_element = [self search:a class:@"market_listing_item_name"];
//                TFHppleElement *qty_element = [self search:a class:@"market_listing_num_listings_qty"];
                TFHppleElement *price_element = [self search:a class:@"normal_price"];
                
                NSString *name = [name_element firstTextChild].content;
//                NSString *qty = [qty_element firstTextChild].content;
                NSString *price = [price_element firstTextChild].content;
                
                SPMarketItem *aItem = [SPMarketItem new];
                aItem.name = name;
//                aItem.qty = qty;
                aItem.price = price;
                aItem.href = href;
                [list addObject:aItem];
            }
            RunOnMainQueue(^{
                self.list = list;
                [self.tableView reloadData];
                if (self.heightDidChanged) {
                    self.heightDidChanged([self.tableView contentSize].height);
                }
            });
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPItemPriceCell forIndexPath:indexPath];
    [cell configureWithItem:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPMarketItem *item = self.list[indexPath.row];
    [self willPreviewItem:item];
}

@end
