//
//  SPInventorySegmentPickerVC.m
//  DOTA2ShiPing
//
//  Created by bo wang on 16/7/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "SPInventorySegmentPickerVC.h"
#import "SPLeftAlignmentLayout.h"
#import "UIView+More.h"
#import "SPMacro.h"

static NSUInteger kConclusivePriority = 950;
static NSUInteger kInconclusivePriority = 900;

@interface SPInventorySegmentPickerVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet SPLeftAlignmentLayout *layout;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;

@property (assign, readwrite, getter=isVisible, nonatomic) BOOL visible;

@end

@implementation SPInventorySegmentPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.closeBtn.tintColor = AppBarColor;
    self.layout.maximumInteritemSpacing = 16.f;
}

- (void)show
{
    self.visible = YES;
    
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        [self.titleView setHidden:NO animated:YES];
        [UIView animateWithDuration:.4f animations:^{
            self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.collectionViewBottomConstraint.priority = kConclusivePriority;
            self.collectionViewHeightConstraint.priority = kInconclusivePriority;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)dismiss
{
    [self.titleView setHidden:YES animated:YES];
    [self.collectionView setHidden:YES animated:YES];
    [UIView animateWithDuration:.4f animations:^{
        self.effectView.effect = nil;
    } completion:^(BOOL finished) {
        self.visible = NO;
        [self.collectionView setHidden:NO animated:NO];
        self.collectionViewBottomConstraint.priority = kInconclusivePriority;
        self.collectionViewHeightConstraint.priority = kConclusivePriority;
        [self.view layoutIfNeeded];
    }];
}

- (void)setVisible:(BOOL)visible
{
    [self willChangeValueForKey:@"visible"];
    _visible = visible;
    [self didChangeValueForKey:@"visible"];
}

- (IBAction)close:(id)sender
{
    [self dismiss];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SPInventorySegmentPickerCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = CGRectGetHeight(cell.frame)/2;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = .5f;
    
    UILabel *label = [cell viewWithTag:10086];
    label.text = self.titles[indexPath.item];
    label.textColor = (indexPath.item==self.currentIndex)?AppBarColor:[UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSString *text = self.titles[indexPath.item];
    CGSize size = [text sizeWithAttributes:attribute];
    return CGSizeMake(ceilf(size.width) + 24.f, 28.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex != indexPath.item) {
        self.currentIndex = indexPath.item;
        if (self.didSelectedIndex) {
            self.didSelectedIndex(indexPath.item);
        }
    }
}

@end
