//
//  SPPlayerDetailInfoVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/3.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPPlayerDetailInfoVC.h"
#import "SPSteamAPI.h"
#import "SPPlayer.h"
#import "DDProgressHUD.h"
#import "SPMacro.h"
#import "SPConstant.h"
#import "SPPlayerAliasesVC.h"
#import "SPPlayerInventoryVC.h"
#import "SPPlayerManager.h"
#import "SPPlayer+More.h"
#import "YYWebImage.h"

static NSString *SPPlayerDetailItemsTagCell = @"SPPlayerDetailItemsTagCell";

static NSString *kSPPlayerAliasesListSegueID = @"SPPlayerAliasesListSegueID";
static NSString *kSPPlayerInventorySegueID = @"SPPlayerInventorySegueID";

@interface SPPlayerDetailInfoCel : UITableViewCell
@end
@implementation SPPlayerDetailInfoCel
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
}
@end

@interface SPPlayerDetailInfoVC () <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemsTagCellHeight;
    BOOL _loadData;
}

#pragma mark - Section 0
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *baseInfoCell;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *steamidLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliasesLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllAliaseBtn;

#pragma mark - Section 1
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *stateInfoCell;
@property (weak, nonatomic) IBOutlet UILabel *playerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerStateDetailLabel;

#pragma mark - Section 2
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *itemTagCell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *itemLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *itemTagCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *showItemsDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showItemsDetailBtnHeightConstraint;

#pragma mark - Section 3
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *gotoSteamCell;
@property (weak, nonatomic) IBOutlet UIButton *gotoSteamBtn;

#pragma mark - Section 4
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *gotoDotamaxCell;
@property (weak, nonatomic) IBOutlet UIButton *gotoDotamaxBtn;

#pragma mark - Section 5
@property (weak, nonatomic) IBOutlet SPPlayerDetailInfoCel *gotoDotabuffCell;
@property (weak, nonatomic) IBOutlet UIButton *gotoDotabuffBtn;

@property (strong, nonatomic) SPPlayerDetailInfo *info;
@property (strong, nonatomic) NSArray<SPPlayerAliase *> *aliase;
@property (strong, nonatomic) SPPlayerItemsList *itemsList;
@property (strong, nonatomic) NSArray *tagList;

@end

@implementation SPPlayerDetailInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loadData = YES;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 4.f;
    
    [self.itemLoadingIndicator setTintColor:AppBarColor];
    
    _itemsTagCellHeight = 50.f;
    
    DDProgressHUD *HUD = [DDProgressHUD showAnimatedLoadingInView:[UIApplication sharedApplication].keyWindow];
    
    // 用户信息
    [[SPSteamAPI shared] fetchPlayerSummarie:[self.player steamid17] completion:^(BOOL suc, id object) {
        if (suc) {
            [HUD hide:YES];
            self.info = object;
            [self update];
        }else{
            [HUD showAutoHiddenHUDWithMessage:@"获取用户数据失败!"];
        }
    }];
    
    // 曾用名
    [[SPSteamAPI shared] fetchPlayerAliases:[self.player steamid17] completion:^(BOOL suc, id object) {
        if (suc) {
            self.aliase = object;
            [self updateAliase];
        }
    }];
    
    // 饰品列表
    [[SPSteamAPI shared] fetchPlayerItems:[self.player steamid17] completion:^(SPPlayerItemsList *list) {
        if (list.status != SPPlayerItemsListStatusSuccess) {
            self.itemsList = list;
            [self updateItemsList];
        }else{
            [self computeItemTags:list];
        }
    }];
}

- (void)dealloc
{
    NSString *class = NSStringFromClass([self class]);
    NSLog(@"%@释放！！！",class);
}

- (void)update
{
    if (self.info) {
        _loadData = NO;
        
        [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.info.avatarfull] placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        self.nickNameLabel.text = self.info.personaname;
        self.steamidLabel.text = [NSString stringWithFormat:@"SteamID:%lld",self.info.steamid.longLongValue-BaseSteamID()];
        self.aliasesLabel.hidden = YES;
        self.showAllAliaseBtn.hidden = YES;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
        
        BOOL isPrivate = [self isPrivate];
        
        SPPlayerPersonaState state = self.info.personastate.integerValue;
        if (state == SPPersonaState_OfflineOrPrivate) {
            self.playerStateLabel.text = @"离线";
            self.playerStateDetailLabel.text = isPrivate?@"该用户资料为私密的":nil;
            self.playerStateLabel.textColor = RGBColor(185, 185, 185, 1);
            self.playerStateDetailLabel.textColor = RGBColor(185, 185, 185, 1);
            
            if (self.info.lastlogoff) {
                NSTimeInterval lastlogoff = self.info.lastlogoff.doubleValue;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastlogoff];
                NSString *dateString = [formatter stringFromDate:date];
                self.playerStateDetailLabel.text = [NSString stringWithFormat:@"上次在线：%@",dateString];
            }
        }else{
            NSString *text = @"在线";
            NSString *subText;
            switch (state) {
                case SPPersonaState_OfflineOrPrivate:break;
                case SPPersonaState_Online: {
                    subText = @"在线";
                    break;
                }
                case SPPersonaState_Busy: {
                    subText = @"忙碌";
                    break;
                }
                case SPPersonaState_Away: {
                    subText = @"离开";
                    break;
                }
                case SPPersonaState_Snooze: {
                    subText = @"打盹中";
                    break;
                }
                case SPPersonaState_LookingToTrade: {
                    subText = @"想交易";
                    break;
                }
                case SPPersonaState_LookingToPlay: {
                    subText = @"想玩游戏";
                    break;
                }
            }
            if (self.info.gameextrainfo) {
                text = subText;
                subText = [NSString stringWithFormat:@"正在玩：%@",self.info.gameextrainfo];
            }
            self.playerStateLabel.textColor = RGBColor(104, 203, 242, 1);
            self.playerStateDetailLabel.textColor = RGBColor(104, 203, 242, 1);
            self.playerStateLabel.text = text;
            self.playerStateDetailLabel.text = subText;
        }
        
        [self.tableView reloadData];
        
        [self updateAliase];
        [self updateItemsList];
    }
}

- (void)updateAliase
{
    if (self.info && self.aliase && self.aliase.count > 0) {
        self.aliasesLabel.hidden = NO;
        self.showAllAliaseBtn.hidden = NO;
        NSMutableArray *a = [NSMutableArray array];
        for (SPPlayerAliase *aliase in self.aliase) {
            [a addObject:aliase.newname];
        }
        self.aliasesLabel.text = [NSString stringWithFormat:@"曾用名：%@",[a componentsJoinedByString:@"，"]];;
    }else{
        self.aliasesLabel.hidden = YES;
        self.showAllAliaseBtn.hidden = YES;
    }
}

- (void)updateItemsList
{
    if (self.info && self.itemsList) {
        
        [self.itemLoadingIndicator stopAnimating];
        
        SPPlayerItemsListStatus status = self.itemsList.status;
        switch (status) {
            case SPPlayerItemsListStatusFailure: {
                self.itemTitleLabel.text = @"获取数据失败";
                break;
            }
            case SPPlayerItemsListStatusSuccess: {
                self.showItemsDetailBtn.hidden = NO;
                self.itemTitleLabel.text = [NSString stringWithFormat:@"物品库存：%lu 件",(unsigned long)[self.itemsList.items count]];
                self.itemTitleLabel.textAlignment = NSTextAlignmentLeft;
                
                CGRect frame = self.itemTagCollectionView.frame;
                frame.size.width = DeviceWidth;
                self.itemTagCollectionView.frame = frame;
                [self.itemTagCollectionView reloadData];
                
                [self.itemTagCollectionView performBatchUpdates:^{
                    
                } completion:^(BOOL finished) {
                    CGFloat h = ceilf(self.itemTagCollectionView.contentSize.height);
                    _itemsTagCellHeight = 50.f + h + 44.f;
                    self.showItemsDetailBtnHeightConstraint.constant = 44.f;
                    self.itemTagCollectionView.hidden = NO;
                    [self.tableView reloadData];
                }];
                break;
            }
            case SPPlayerItemsListStatusInvalid: {
                self.itemTitleLabel.text = @"Steamid错误";
                break;
            }
            case SPPlayerItemsListStatusPrivate: {
                self.itemTitleLabel.text = @"该用户库存资料为私密的";
                break;
            }
            case SPPlayerItemsListStatusNotExist: {
                self.itemTitleLabel.text = @"该用户不存在";
                break;
            }
        }
        self.itemTitleLabel.hidden = NO;
        [self.itemLoadingIndicator stopAnimating];
        if (status != SPPlayerItemsListStatusSuccess) {
            self.itemTitleLabel.textColor = AppBarColor;
        }
    }
}

- (void)computeItemTags:(SPPlayerItemsList *)list
{
    RunOnSubThread(^{
        SPDataManager *m = [SPDataManager shared];
        FMDatabase *db = m.db;
        
        NSMutableDictionary *allItems = [NSMutableDictionary dictionary];
        FMResultSet *result = [db executeQuery:@"SELECT token,item_rarity FROM items"];
        
        int tokenIndex = [result columnIndexForName:@"token"];
        int rarityIndex = [result columnIndexForName:@"item_rarity"];
        
        while ([result next]) {
            NSUInteger token = [result intForColumnIndex:tokenIndex];
            NSString *rarity = [result stringForColumnIndex:rarityIndex];
            allItems[@(token)] = rarity;
        }
        [result close];
        
        NSMutableDictionary *tagsDict = [NSMutableDictionary dictionary];
        SPPlayerItemsList *theList = list;
        for (SPPlayerItem *item in theList.items) {
            NSString *rarity = allItems[item.defindex];
            rarity = rarity?:@"Unknown";
            tagsDict[rarity] = @(1 + [tagsDict[rarity] integerValue]);
        }
        
        NSMutableArray *tags = [NSMutableArray array];
        for (NSString *rarityName in tagsDict) {
            NSNumber *count = tagsDict[rarityName];
            
            SPItemRarity *rarity = [m rarityOfName:rarityName];
            if (rarity) {
                SPItemColor *color = [m colorOfName:rarity.color];
                [tags addObject:@[rarity.name_cn,count,color.color,rarity.value]];
            }else{
                //未知
                [tags addObject:@[rarityName,count,[UIColor lightGrayColor],@(NSNotFound)]];
            }
        }
        
        [tags sortUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
            return [[obj1 lastObject] compare:[obj2 lastObject]];
        }];
        
        RunOnMain(^{
            self.itemsList = list;
            self.tagList = tags;
            [self updateItemsList];
        });
    });
}

- (BOOL)isPrivate
{
    SPPlayerCommunityVisibilityState cvState = self.info.communityvisibilitystate.integerValue;
    return (cvState != SPCVState_Public && cvState != SPCVState_FriendsOfFriends);
}

#pragma mark - Action
- (IBAction)moreAction:(UIBarButtonItem *)sender
{
    [self.player starOrUnstar];
}

- (IBAction)showInventory:(UIButton *)sender
{
    DDProgressHUD *HUD = [DDProgressHUD showHUDAddedTo:self.view.window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.progress = 0;
    HUD.labelText = @"正在获取...";
    
    NSString *newMD5 = self.itemsList.MD5;
    NSString *oldMD5 = [[SPPlayerManager shared] itemsEigenvalueOfPlayer:self.player.steam_id];
    
//    NSNumber *newValue = self.itemsList.eigenvalue;
//    NSNumber *oldValue = [[SPPlayerManager shared] itemsEigenvalueOfPlayer:self.player.steam_id];
    [[SPPlayerManager shared] readArchivedPlayerInventory:self.player];
    
    BOOL notNeedUpdate = newMD5 && oldMD5 && [oldMD5 isEqualToString:newMD5] && nil!=self.player.inventory;
    if (notNeedUpdate) {
        NSLog(@"不需要更新库存");
        [HUD hide:YES];
        [self performSegueWithIdentifier:kSPPlayerInventorySegueID sender:self.player];
        return;
    }
    
    NSUInteger allCount = self.itemsList.items.count;
    
    [[SPSteamAPI shared] fetchPlayerInventory:[self.player steamid17]
                                   itemsCount:@(allCount)
                                     progress:^(NSProgress *progress) {
            
                                         NSUInteger completedPages = progress.completedUnitCount;
                                         NSUInteger totalPages = progress.totalUnitCount;
                                        
                                         HUD.mode = MBProgressHUDModeDeterminate;
                                         HUD.progress = completedPages/(CGFloat)totalPages;
                                         HUD.labelText = [NSString stringWithFormat:@"第 %lu/%lu 页",(unsigned long)completedPages,(unsigned long)totalPages];
                                     }
                                   completion:^(BOOL suc, id object) {
                                      
                                       if (suc) {
                                           self.player.inventory = object;
                                           self.player.itemList = self.itemsList;
                                           
                                           // 要将defindex注入进去
                                           [self.player.inventory infuseItemList:self.itemsList];
                                           
                                           [[SPPlayerManager shared] saveArchivedPlayerInventory:self.player];
                                           [[SPPlayerManager shared] setItemsEigenvalue:newMD5 forPlayer:self.player.steam_id];
        
                                           [HUD hide:YES];
                                           [self performSegueWithIdentifier:kSPPlayerInventorySegueID sender:self.player];
                                           
                                       }else{
                                           [HUD showAutoHiddenHUDWithMessage:object];
                                       }
                                   }];
}

- (IBAction)gotoSteam:(id)sender {
}
- (IBAction)gotoDotamax:(id)sender {
}
- (IBAction)gotoDotabuff:(id)sender {
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _loadData?0:4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.f;
    switch (indexPath.section) {
        case 0:height = 88.f;break;
        case 1:height = 44.f;break;
        case 2:height = _itemsTagCellHeight;break;
        case 3:height = 44.f;break;
        default:break;
    }
    return height;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPPlayerDetailItemsTagCell forIndexPath:indexPath];
    NSArray *tag = self.tagList[indexPath.item];
    UILabel *label = [cell viewWithTag:10086];
    label.text = [NSString stringWithFormat:@"%@ %@",tag[0],tag[1]];
    cell.backgroundColor = tag[2];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4.f;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tag = self.tagList[indexPath.item];
    NSString *tagName = [NSString stringWithFormat:@"%@ %@",tag[0],tag[1]];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGFloat width = [tagName sizeWithAttributes:attributes].width;
    return CGSizeMake(ceilf(width)+20, 26);
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSPPlayerAliasesListSegueID]) {
        SPPlayerAliasesVC *vc = segue.destinationViewController;
        vc.aliasesList = self.aliase;
    }else if ([segue.identifier isEqualToString:kSPPlayerInventorySegueID]){
        SPPlayerInventoryVC *vc = segue.destinationViewController;
        vc.player = self.player;
    }
}

@end
