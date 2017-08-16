//
//  SPWorkshopTagVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/17.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPWorkshopTagVC.h"

#import "SPItemHeroPickerVC.h"
#import "AMPopTip.h"

static NSString *const kSPWorkshopTagCell = @"SPWorkshopTagCell";

#pragma mark - TVC
@interface SPWorkshopTagTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (assign, nonatomic) SPWorkshopSection section;
@property (strong, nonatomic) NSArray<SPWorkshopTag *> *selectedTags;
@property (strong, nonatomic) NSMutableArray<NSDictionary<NSString *, NSArray<SPWorkshopTag *> *> *> *allTags;
@property (copy, nonatomic) SPWorkshopTagCompletion completion;

@property (assign, nonatomic) BOOL isHeroSegment;       //segment是否为英雄
@property (assign, nonatomic) BOOL heroVisible;         //是否应该显示英雄标签
@property (assign, nonatomic) BOOL heroSlotVisible;     //是否应该显示英雄部位标签

@property (strong, nonatomic) SPHero *hero; //已选择的英雄
@property (strong, nonatomic) SPWorkshopTag *heroTag;
@property (strong, nonatomic) NSArray<SPWorkshopTag *> *heroSlotTags; //对应已选择的英雄的部位tag

- (void)setup:(SPWorkshop *)workshop
   completion:(SPWorkshopTagCompletion)completion;
@end

@implementation SPWorkshopTagTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isHeroSegment = YES;
    [self setupHero:nil];

    self.allTags = [SPWorkshop tagsOfSection:self.section];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSDictionary *tagDict in self.allTags) {
        NSString *k = [[[tagDict allKeys] firstObject] lowercaseString];
        if ([k isEqualToString:@"heroes"]) {
            self.heroVisible = YES;
            [indexSet addIndex:[self.allTags indexOfObject:tagDict]];
        }else if ([k isEqualToString:@"slots"]){
            self.heroSlotVisible = YES;
            [indexSet addIndex:[self.allTags indexOfObject:tagDict]];
        }
    }
    [self.allTags removeObjectsAtIndexes:indexSet];
    
    self.tableView.editing = YES;
}

- (void)setup:(SPWorkshop *)workshop
   completion:(SPWorkshopTagCompletion)completion
{
    NSArray *curTags = workshop.query.requiredtags;
    self.selectedTags = curTags;
    self.section = workshop.query.section;
    self.completion = completion;
}

- (IBAction)exit:(id)sender
{
    if (self.completion) {
        self.completion(YES,nil);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedTags = [NSMutableArray array];
    if (self.isHeroSegment) {
        SPWorkshopTag *tag0 = self.heroTag;
        if (tag0) {
            [selectedTags addObject:tag0];
        }
        for (NSIndexPath *indexPath in indexPaths) {
            if (indexPath.section == 1) {
                SPWorkshopTag *slotTag = self.heroSlotTags[indexPath.row];
                [selectedTags addObject:slotTag];
            }
        }
    }else{
        for (NSIndexPath *indexPath in indexPaths) {
            SPWorkshopTag *tag = [[self.allTags[indexPath.section] allValues] firstObject][indexPath.row];
            [selectedTags addObject:tag];
        }
    }
    if (self.completion) {
        self.completion(NO,selectedTags);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    self.isHeroSegment = !self.isHeroSegment;
    [self.tableView reloadData];
}

#pragma mark - Data
- (void)setupHero:(SPHero *)hero
{
    if (!hero) {
        self.heroTag = [SPWorkshopTag new];
        self.heroTag.text = @"选择英雄";
        self.heroSlotTags = nil;
        self.hero = nil;
    }else{
        self.hero = hero;
        self.heroTag = [SPWorkshopTag tagOfHero:hero];
        self.heroSlotTags = [SPWorkshopTag tagsOfHeroSlots:hero];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isHeroSegment) {
        return self.heroVisible?(self.heroSlotVisible?2:1):0;
    }
    return self.allTags.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isHeroSegment) {
        return section==0?1:self.heroSlotTags.count;
    }else{
        return [[self.allTags[section] allValues] firstObject].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPWorkshopTagCell forIndexPath:indexPath];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SPWorkshopTag *tag;
    if (self.isHeroSegment) {
        tag = section==0?self.heroTag:self.heroSlotTags[row];
    }else{
        tag = [[self.allTags[section] allValues] firstObject][row];
    }
    cell.textLabel.text = tag.text;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isHeroSegment) {
        return section==0?@"英雄":@"SLOTS";
    }
    return [[self.allTags[section] allKeys] firstObject];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.isHeroSegment && section == 1) {
        return @"选择英雄后将显示所有英雄可装备饰品部位。";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger secion = indexPath.section;
    if (self.isHeroSegment) {
        if (secion == 0) {
            ygweakify(self);
            [SPItemHeroPickerVC presentFrom:self selectedCallback:^BOOL(SPHero *hero) {
                ygstrongify(self);
                [self setupHero:hero];
                [self.tableView reloadData];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                return YES;
            }];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    if (self.isHeroSegment) {
        if (section == 0) {
            [self setupHero:nil];
            [self.tableView reloadData];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end

#pragma mark - UINavigation
@interface SPWorkshopTagVC ()
@end
@implementation SPWorkshopTagVC
- (void)setup:(SPWorkshop *)workshop
   completion:(SPWorkshopTagCompletion)completion
{
    SPWorkshopTagTVC *tvc = [self.viewControllers firstObject];
    [tvc setup:workshop completion:completion];
}

@end
