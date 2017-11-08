//
//  SPItemSteamPricesViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/11/8.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemSteamPricesViewCtrl.h"
#import "SPItem.h"
#import "SPItemPriceLoader.h"
#import "TFHpple.h"
#import "YGRefreshComponent.h"
#import "SPItemSteamPriceCell.h"

@interface SPItemSteamPricesViewCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (strong, nonatomic) NSMutableArray *priceList;
@property (assign, nonatomic) NSInteger pageNo;

@property (assign, nonatomic) BOOL inLoading;

@end

@implementation SPItemSteamPricesViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.priceList = [NSMutableArray array];
    
    self.pageNo = 0;
    [self loadData:self.pageNo];
}

- (void)loadData:(NSInteger)pageNo
{
    [SPItemPriceLoader loadSteamMarketPriceList:self.item pageNo:pageNo completion:^(SPItemSteamPrice *price) {
        [self parsePrice:price page:pageNo];
    }];
}

- (void)parsePrice:(SPItemSteamPrice *)price page:(NSInteger)pageNo
{
    [self.tableView resetRefreshing];
    if (price.error.length > 0) {
        [SVProgressHUD showErrorWithStatus:price.error];
        return;
    }
    if (!price.list.success) {
        // 没有更多了
        [self.tableView setNoMoreData];
        return;
    }
    
    [self.priceList addObjectsFromArray:price.items];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.priceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPItemSteamPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPItemSteamPriceCell forIndexPath:indexPath];
    [cell configureWithPrice:self.priceList[indexPath.row]];
    return cell;
}


@end
