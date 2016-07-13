//
//  SPPlayerListVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/5/29.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerListVC.h"
#import "SPSearchVC.h"
#import "SPMacro.h"
#import "SPPlayerManager.h"
#import "LCActionSheet.h"
#import "SPPlayerCell.h"
#import "SPLogoHeader.h"
#import "SPPlayerInventorySearchAllPlayerVC.h"
#import "SPPlayerDetailInfoVC.h"
#import "SPPlayer+More.h"
#import "PinYin4Objc.h"
#import "UIImage+YYAdd.h"
#import "RWDropdownMenu.h"
#import "SPPopoverView.h"

// 搜索用户
static NSString *const kSPPlayerSearchSegueID = @"SPPlayerSearchSegueID";
// 用户个人信息详情
static NSString *const kSPPlayerDetailSegueID = @"SPPlayerDetailSegueID";

@interface SPPlayerListVC () <UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tagBtnItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateBtnItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchCtrl;
@property (strong, nonatomic) NSMutableArray<NSMutableDictionary<NSString *,NSMutableArray<SPPlayer *>*> *> *playerList;
@property (strong, nonatomic) NSArray *sectionTitles;
@end

@implementation SPPlayerListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionIndexMinimumDisplayRowCount = 2;
    self.tableView.sectionIndexColor = AppBarColor;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    [SPLogoHeader setLogoHeaderInScrollView:self.tableView];
    
    SPPlayerInventorySearchAllPlayerVC *vc = [SPPlayerInventorySearchAllPlayerVC instanceFromStoryboard];
    self.searchCtrl = [[UISearchController alloc] initWithSearchResultsController:vc];
    vc.searchCtrl = self.searchCtrl;
    self.searchCtrl.searchResultsUpdater = vc;
    self.searchCtrl.delegate = self;
    
    self.definesPresentationContext = YES;
    
    [self.searchCtrl.searchBar sizeToFit];
    [self.searchCtrl.searchBar setBackgroundImage:[UIImage imageWithColor:RGBColor(247, 247, 247, 1)]];
    self.searchCtrl.searchBar.placeholder = @"在所有库存中搜索";
    self.tableView.tableHeaderView = self.searchCtrl.searchBar;
    
    spweakify(self);
    [[SPPlayerManager shared] setStarredUpdatedCallback:^{
        spstrongify(self);
        [self update];
    }];
    [self update];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPPlayerSearchSegueID]) {
        SPSearchVC *vc = segue.destinationViewController;
        vc.type = [sender integerValue];
    }else if ([segue.identifier isEqualToString:kSPPlayerDetailSegueID]){
        SPPlayerDetailInfoVC *vc = segue.destinationViewController;
        vc.player = sender;
    }
}

#pragma mark - Data

- (void)update
{
    NSArray *starredPlayers = [[SPPlayerManager shared] starredPlayers];
    
    NSMutableArray *list = [NSMutableArray array];
    
    NSMutableDictionary *pinyinDict = [NSMutableDictionary dictionary];
    NSMutableArray *(^PinyinArray)(NSString *pinyin) = ^NSMutableArray *(NSString *pinyin){
        NSString *k = (pinyin.length > 0)?[pinyin uppercaseString]:@"#";
        if (!pinyinDict[k]) {
            pinyinDict[k] = [NSMutableArray array];
        }
        return pinyinDict[k];
    };
    
    for (SPPlayer *player in starredPlayers) {
        NSString *name = player.name;
        NSString *pinyinC;
        
        if (name.length > 0) {
            unichar c = [name characterAtIndex:0];
            NSArray *pinyin = [PinyinHelper toHanyuPinyinStringArrayWithChar:c];
            if (pinyin.count > 0) {
                NSString *s = [pinyin firstObject];
                if (s.length > 0){
                    pinyinC = [s substringToIndex:1];
                }
            }else{
                if ( (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ) {
                    pinyinC = [NSString stringWithFormat:@"%C",c];
                }
            }
        }
        NSMutableArray *array = PinyinArray(pinyinC);
        [array addObject:player];
    }
    for (NSString *k in pinyinDict) {
        id v = pinyinDict[k];
        [list addObject:@{k:v}.mutableCopy];
    }
    [list sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSString *k1 = [[obj1 allKeys] firstObject];
        NSString *k2 = [[obj2 allKeys] firstObject];
        return [k1 compare:k2];
    }];
    NSMutableArray *sectionTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in list) {
        [sectionTitles addObject:[[dict allKeys] firstObject]];
    }
    self.playerList = list;
    self.sectionTitles = sectionTitles;
    [self.tableView reloadData];
    
    
    
}

#pragma mark - PopTips
- (void)showUpdatePopTips
{
    
}

#pragma mark - Actions
- (IBAction)add:(id)sender
{
    spweakify(self);
    void (^action)(SPSearchType type) = ^(SPSearchType type){
        spstrongify(self);
        if (IsSearchPlayer(type)) {
            [self segueToSearchWithType:type];
        }
    };
    
    PopoverView *view = [[PopoverView alloc] init];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                NSForegroundColorAttributeName:[UIColor whiteColor]};
    view.attributedMenuTitles = @[  [[NSAttributedString alloc] initWithString:@"DotaMax" attributes:attribute],
                                    [[NSAttributedString alloc] initWithString:@"Dotabuff" attributes:attribute],
                                    [[NSAttributedString alloc] initWithString:@"Steam" attributes:attribute]];
    view.popoverBackgroundColor = AppBarColor2;
    view.borderHidden = YES;
    
    [view showFromRectOfScreen:CGRectMake(DeviceWidth-8-40, 27, 40, 30) selected:^(NSInteger index) {
        action(index);
    }];
    return;

//    // 如果配置了搜索方式，使用这个搜索方式。否则，让用户选择搜索方式。
//    SPSearchType type = UserSearchType();
//    if (IsSearchPlayer(type)) {
//        [self segueToSearchWithType:type];
//    }else{
//        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"数据来源\n你可以在设置内配置默认来源站点" buttonTitles:@[@"DotaMax",@"Dotabuff",@"Steam Community"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
//            SPSearchType theType = -1;
//            if (buttonIndex == 0) {
//                theType = SPSearchTypeMaxPlusPlayer;
//            }else if (buttonIndex == 1){
//                theType = SPSearchTypeDotabuffPlayer;
//            }else if (buttonIndex == 2){
//                theType = SPSearchTypeSteamCommunityPlayer;
//            }
//            if (IsSearchPlayer(theType)) {
//                [self segueToSearchWithType:theType];
//            }
//        }];
//        sheet.textFont = [UIFont systemFontOfSize:16];
//        [sheet show];
//    }
}

- (void)segueToSearchWithType:(SPSearchType)type
{
    [self performSegueWithIdentifier:kSPPlayerSearchSegueID sender:@(type)];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.playerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *d = self.playerList[section];
    return [[[d allValues] firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    
    SPPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPPlayerCell forIndexPath:indexPath];
    NSDictionary *d = self.playerList[section];
    NSArray *players = [[d allValues] firstObject];
    SPPlayer *player = players[row];
    [cell configureWithPlayer:player];
    [cell setInfoBtnAction:^(SPPlayer *p) {
        [p starOrUnstar];
    }];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *d = self.playerList[section];
    return [[d allKeys] firstObject];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return MAX(0, index-1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *d = self.playerList[indexPath.section];
    SPPlayer *player = [[d allValues] firstObject][indexPath.row];
    [self performSegueWithIdentifier:kSPPlayerDetailSegueID sender:player];
    NSLog(@"%@",player.name);
}

#pragma mark - UISearchController
- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
}

@end
