//
//  SPInventoryCategoryPickerVC.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 16/7/9.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPInventoryCategoryPickerVC.h"
#import "SPDataManager.h"


static NSUInteger kConclusivePriority = 950;
static NSUInteger kInconclusivePriority = 900;

static NSString *const kSPInventoryCategoryCell = @"SPInventoryCategoryCell";

@interface SPInventoryCategoryPickerVC () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint; //900/950
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint; //950/900

@property (assign, nonatomic) SPInventoryCategory index;
@property (assign, readwrite, getter=isVisible, nonatomic) BOOL visible;
@end

@implementation SPInventoryCategoryPickerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _index = SPInventoryCategoryAll;
    
    self.categoryTitles = @[@"全部",@"特殊事件",@"英雄",@"信使",@"世界",@"界面",@"音频",@"珍藏",@"其他",@"可交易或可出售",@"自定义条件"];
}

- (void)dealloc
{
    NSString *class = NSStringFromClass([self class]);
    NSLog(@"%@释放！！！",class);
}

- (void)show
{
    if (self.visible) return;
    
    self.visible = YES;
    [UIView animateWithDuration:.4f animations:^{
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.view.userInteractionEnabled = YES;
        self.tableViewBottomConstraint.priority = kConclusivePriority;
        self.tableViewHeightConstraint.priority = kInconclusivePriority;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    if (!self.visible) return;
    
    [UIView animateWithDuration:.4f animations:^{
        self.effectView.effect = nil;
        self.view.userInteractionEnabled = NO;
        self.tableViewBottomConstraint.priority = kInconclusivePriority;
        self.tableViewHeightConstraint.priority = kConclusivePriority;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.visible = NO;
    }];
}

- (void)setVisible:(BOOL)visible
{
    [self willChangeValueForKey:@"visible"];
    _visible = visible;
    [self didChangeValueForKey:@"visible"];
}

- (NSString *)titleForCategory:(SPInventoryCategory)index
{
    if (index < self.categoryTitles.count) {
        return self.categoryTitles[index];
    }
    return nil;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSPInventoryCategoryCell forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    UILabel *label = [cell viewWithTag:10086];
    label.text = self.categoryTitles[indexPath.row];
    label.textColor = _index==indexPath.row?kRedColor:[UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:_index inSection:0],indexPath];
    _index = indexPath.row;
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    if (self.didSelectedCategory) {
        self.didSelectedCategory(_index);
    }
    [self dismiss];
}

@end
