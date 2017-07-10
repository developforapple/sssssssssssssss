//
//  SPPlayerAliasesVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerAliasesVC.h"
#import "SPPlayer.h"

static NSString *kSPPlayerAliaseCell = @"SPPlayerAliaseCell";

@interface SPPlayerAliasesVC ()
@end

@implementation SPPlayerAliasesVC

- (void)dealloc
{
    NSString *class = NSStringFromClass([self class]);
    NSLog(@"%@释放！！！",class);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aliasesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPPlayerAliaseCell forIndexPath:indexPath];
    
    SPPlayerAliase *aliase = self.aliasesList[indexPath.row];
    
    cell.textLabel.text = aliase.newname;
    cell.detailTextLabel.text = aliase.timechanged;
    
    return cell;
}
@end
