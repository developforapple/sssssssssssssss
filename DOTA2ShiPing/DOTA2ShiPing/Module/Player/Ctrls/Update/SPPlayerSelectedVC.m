//
//  SPPlayerSelectedVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/14.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerSelectedVC.h"
#import "SPMacro.h"
#import "SPPlayerManager.h"
#import "SPPlayerCell.h"

@interface SPPlayerSelectedVC ()
@property (strong, nonatomic) NSMutableArray<SPPlayer *> *starredPlayers;
@property (strong, nonatomic) NSArray<NSNumber *> *updatePlayerList;
@property (assign, nonatomic) NSInteger remainCount;
@end

@implementation SPPlayerSelectedVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _remainCount = [[SPPlayerManager shared] supportAccountCount];
    
    self.updatePlayerList = [[SPPlayerManager shared] updateListPlayers];
    self.starredPlayers = [[[SPPlayerManager shared] starredPlayers] mutableCopy];
    self.tableView.editing = YES;
    for (SPPlayer *player in self.starredPlayers) {
        if ([self.updatePlayerList containsObject:player.steam_id]) {
            NSUInteger row = [self.starredPlayers indexOfObject:player];
            NSIndexPath *p = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:p animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self updateTitle];
}

- (void)updateTitle
{
    NSArray *list = [self.tableView indexPathsForSelectedRows];
    NSUInteger count = list.count;
    
    NSUInteger allowCount = [[SPPlayerManager shared] supportAccountCount];
    _remainCount = allowCount-count;
    self.navigationItem.title = [NSString stringWithFormat:@"还可以选择 %ld 个账号",(long)_remainCount];
}

- (IBAction)done:(UIBarButtonItem *)item
{
    if (_remainCount < 0) {
        NSString *msg = [NSString stringWithFormat:@"您最多可选择 %d 个账号",[[SPPlayerManager shared] supportAccountCount]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSMutableArray *players = [NSMutableArray array];
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPaths) {
        NSUInteger r = indexPath.row;
        SPPlayer *p = self.starredPlayers[r];
        [players addObject:p.steam_id];
    }
    [[SPPlayerManager shared] setUpdateListPlayers:players];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pro:(UIButton *)sender
{
    [self.tabBarController setSelectedIndex:3];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:@"TODO" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//    [alert show];
}

- (IBAction)extraPlayerPosition:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TODO" message:@"TODO" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.starredPlayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPPlayerCell forIndexPath:indexPath];
    [cell configureWithPlayer:self.starredPlayers[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateTitle];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateTitle];
}

//#pragma mark - Moving
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//#pragma mark - Editing
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSUInteger source = sourceIndexPath.row;
//    NSUInteger destination = destinationIndexPath.row;
//    if (source == destination) {
//        return;
//    }
//    
//    SPPlayer *player = self.starredPlayers[source];
//    [self.starredPlayers removeObject:player];
//    [self.starredPlayers insertObject:player atIndex:destination];
//}

#pragma mark - HeaderFooter
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"选择账号，即可将其加入到库存管理列表。";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"多账户的库存管理是本应用的高级功能。\n\n在默认条件下，您最多可添加 2 个账户进入管理列表。\n\n升级至“专业版”后，管理列表将扩展到 10 个。\n\n您还可以选择购买额外的列表位置。";
}

@end
