//
//  SPItemFilterViewCtrl.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/8/16.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemFilterViewCtrl.h"
#import "SPFilterOption.h"
#import "SPDataManager.h"
#import "SPItemHeroPickerVC.h"

@interface SPItemFilterViewCtrl () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<SPFilterOptionGroup *> *groups;
@property (strong, nonatomic) NSArray *lastOptions;
@property (assign, nonatomic) SPFilterOptionType types;
@property (copy, nonatomic) SPItemFilterCompletion completion;
@end

@implementation SPItemFilterViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self leftNavButtonImg:@"icon_navi_cancel"];
    
    [self loadData];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = YES;
}

- (void)loadData
{
    SPFilterOptionGroup *heroGroup = [SPFilterOptionGroup heroGroup:[SPFilterOption emptyHeroOption]];
    SPFilterOptionGroup *rarityGroup = [SPFilterOptionGroup rarityGroup:[SPDataManager shared].rarities];
    SPFilterOptionGroup *eventGroup = [SPFilterOptionGroup eventGroup:[SPDataManager shared].events];
    self.groups = @[heroGroup,rarityGroup,eventGroup];
}

- (void)setup:(SPFilterOptionType)types
      options:(NSArray *)options
   completion:(SPItemFilterCompletion)completion
{
    self.types = types;
    self.lastOptions = options;
    self.completion = completion;
}

- (SPFilterOption *)heroOption
{
    if (self.types & SPFilterOptionTypeHero) {
        for (SPFilterOptionGroup *aGroup in self.groups) {
            if (aGroup.type == SPFilterOptionTypeHero) {
                return aGroup.options.firstObject;
            }
        }
    }
    return nil;
}

- (void)setupHero:(SPHero *)hero
{
    SPFilterOption *heroOption = [self heroOption];
    [heroOption updateHero:hero];
}

- (void)doLeftNaviBarItemAction
{
    if (self.completion) {
        self.completion(YES,nil);
    }
    [super doLeftNaviBarItemAction];
}

- (IBAction)done:(id)sender
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray<SPFilterOption *> *selectedTags = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        SPFilterOption *option = [self.groups[indexPath.section] options][indexPath.row];
        [selectedTags addObject:option];
    }
    if (self.completion) {
        self.completion(NO,selectedTags);
    }
    [super doLeftNaviBarItemAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups[section].options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kSPItemFilterOptionCell = @"SPItemFilterOptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPItemFilterOptionCell forIndexPath:indexPath];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SPFilterOption *option = self.groups[section].options[row];
    cell.textLabel.text = option.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groups[section].title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    if (self.groups[section].type == SPFilterOptionTypeHero) {
        ygweakify(self);
        [SPItemHeroPickerVC presentFrom:self selectedCallback:^BOOL(SPHero *hero) {
            ygstrongify(self);
            [self setupHero:hero];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            return YES;
        }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        NSArray<NSIndexPath *> *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
        for (NSIndexPath *aIndexPath in selectedIndexPaths) {
            if (aIndexPath.section == indexPath.section && aIndexPath.row != indexPath.row) {
                [self.tableView deselectRowAtIndexPath:aIndexPath animated:YES];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.groups[indexPath.section].type == SPFilterOptionTypeHero) {
        [self setupHero:nil];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end

@interface SPItemFilterNaviCtrl ()

@end

@implementation SPItemFilterNaviCtrl

- (void)setup:(SPFilterOptionType)types
      options:(NSArray *)options
   completion:(SPItemFilterCompletion)completion
{
    SPItemFilterViewCtrl *vc = [self.viewControllers firstObject];
    [vc setup:types options:options completion:completion];
}

@end
