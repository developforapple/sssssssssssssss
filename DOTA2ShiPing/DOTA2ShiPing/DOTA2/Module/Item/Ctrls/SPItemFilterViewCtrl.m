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
@import ReactiveObjC;

@interface SPItemFilterViewCtrl () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *filterDescView;
@property (weak, nonatomic) IBOutlet UILabel *filterDescLabel;
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
    [self rightNavSystemItem:UIBarButtonSystemItemDone];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = YES;
}

- (void)loadData
{
    NSMutableArray *groups = [NSMutableArray array];
    if (self.types & SPFilterOptionTypeText) {
        SPFilterOptionGroup *textGroup = [SPFilterOptionGroup textGroup];
        [groups addObject:textGroup];
    }
    if (self.types & SPFilterOptionTypeHero) {
        SPFilterOptionGroup *heroGroup = [SPFilterOptionGroup heroGroup:[SPFilterOption emptyHeroOption]];
        [groups addObject:heroGroup];
    }
    if (self.types & SPFilterOptionTypeRarity) {
        SPFilterOptionGroup *rarityGroup = [SPFilterOptionGroup rarityGroup:[SPDataManager shared].rarities];
        [groups addObject:rarityGroup];
    }
    if (self.types & SPFilterOptionTypeEvent) {
        SPFilterOptionGroup *eventGroup = [SPFilterOptionGroup eventGroup:[SPDataManager shared].events];
        [groups addObject:eventGroup];
    }
    self.groups = groups;
    [self.tableView reloadData];
}

- (void)setup:(SPFilterOptionType)types
      options:(NSArray *)options
   completion:(SPItemFilterCompletion)completion
{
    self.types = types;
    self.lastOptions = options;
    self.completion = completion;
    [self loadData];
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

- (SPFilterOption *)textOption
{
    if (self.types & SPFilterOptionTypeText) {
        for (SPFilterOptionGroup *aGroup in self.groups) {
            if (aGroup.type == SPFilterOptionTypeText) {
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
    [self setEditing:NO animated:YES];
    if (self.completion) {
        self.completion(YES,nil);
    }
    [super doLeftNaviBarItemAction];
}

- (void)doRightNaviBarItemAction
{
    [self setEditing:NO animated:YES];
    NSArray *options = [self activatedOptions];
    if (self.completion) {
        self.completion(NO,options);
    }
    [super doLeftNaviBarItemAction];
}

- (void)watchInput:(UITextField *)textField
{
    ygweakify(self);
    [[textField.rac_textSignal
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSString * _Nullable x) {
         ygstrongify(self);
         SPFilterOption *textOption = [self textOption];
         textOption.option = x;
         [self updatedActivatedOptions];
     }];
}

- (NSArray<SPFilterOption *> *)activatedOptions
{
    NSMutableArray<SPFilterOption *> *selectedTags = [NSMutableArray array];
    SPFilterOption *textOption = [self textOption];
    if ([textOption.option isKindOfClass:[NSString  class]] && [textOption.option length] > 0) {
        [selectedTags addObject:textOption];
    }
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPaths) {
        SPFilterOption *option = [self.groups[indexPath.section] options][indexPath.row];
        [selectedTags addObject:option];
    }
    return selectedTags;
}

- (BOOL)noActivatedOptions
{
    if ([[self textOption].option length]) {
        return NO;
    }
    if ([self.tableView indexPathsForSelectedRows].count) {
        return NO;
    }
    return YES;
}

- (void)updatedActivatedOptions
{
    if ([self noActivatedOptions]) {
        [self rightNavButtonText:@"全部"];
    }else{
        [self rightNavSystemItem:UIBarButtonSystemItemDone];
    }
    
//    NSString *desc;
//    NSArray<SPFilterOption *> *options = [self activatedOptions];
//    if (options.count != 0) {
//        NSString *keywords;
//        NSString *hero;
//        NSString *rarity;
//        NSString *event;
//        for (SPFilterOption *aOption in options) {
//            if (aOption.type == SPFilterOptionTypeText) {
//                keywords = aOption.option;
//            }else if (aOption.type == SPFilterOptionTypeHero){
//                hero = aOption.name;
//            }else if (aOption.type == SPFilterOptionTypeRarity){
//                rarity = aOption.name;
//            }else if (aOption.type == SPFilterOptionTypeEvent){
//                event = aOption.name;
//            }
//        }
//        
//        NSMutableArray *lines = [NSMutableArray array];
//        if (keywords) {
//            [lines addObject:[NSString stringWithFormat:@"  \t匹配文本 = “%@”",keywords]];
//        }
//        if (hero) {
//            [lines addObject:[NSString stringWithFormat:@"且\t英雄 = “%@”",hero]];
//        }
//        if (rarity) {
//            [lines addObject:[NSString stringWithFormat:@"且\t稀有度 = “%@”",rarity]];
//        }
//        if (event) {
//            [lines addObject:[NSString stringWithFormat:@"且\t事件 = “%@”",event]];
//        }
//        desc = [lines componentsJoinedByString:@"\n"];
//    }
//    if (desc) {
//        self.filterDescLabel.text = desc;
//        self.tableView.tableHeaderView = self.filterDescView;
//        [self.tableView reloadData];
//    }else{
//        self.tableView.tableHeaderView = nil;
//        [self.tableView reloadData];
//    }
}

#pragma mark - UITableView
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
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SPFilterOption *option = self.groups[section].options[row];
    if (option.type == SPFilterOptionTypeText) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPItemFilterOptionInputCell" forIndexPath:indexPath];
        UITextField *textField = [cell viewWithTag:10086];
        textField.placeholder = option.name;
        [self watchInput:textField];
        return cell;
    }
    static NSString *const kSPItemFilterOptionCell = @"SPItemFilterOptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPItemFilterOptionCell forIndexPath:indexPath];
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
            [self updatedActivatedOptions];
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
    [self updatedActivatedOptions];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.groups[indexPath.section].type == SPFilterOptionTypeHero) {
        [self setupHero:nil];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self updatedActivatedOptions];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPFilterOption *option = self.groups[indexPath.section].options[indexPath.row];
    return option.type != SPFilterOptionTypeText;
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
