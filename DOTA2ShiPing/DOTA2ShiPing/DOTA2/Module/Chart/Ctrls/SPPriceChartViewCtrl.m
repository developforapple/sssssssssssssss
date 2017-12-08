//
//  SPPriceChartViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/28.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPPriceChartViewCtrl.h"
#import "JBLineChartView.h"
#import "SPItem.h"
#import "SPMarketItem.h"
#import "SPSteamAPI.h"
#import "SPPriceUnit.h"
#import "RWDropdownMenu.h"
#import "SPPriceChartConfig.h"

@interface SPPriceChartViewCtrl () <JBLineChartViewDelegate,JBLineChartViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet JBLineChartView *chartView;
@property (weak, nonatomic) IBOutlet UIView *pricePreviewView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIView *dateRangeView;
@property (weak, nonatomic) IBOutlet UILabel *minimumDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumDateLabel;

@property (weak, nonatomic) IBOutlet UIView *priceRangeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceContainerTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *maximumPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumPriceLabel;

@property (strong, nonatomic) NSArray<SPPriceUnit *> *allUnits;

@property (strong, nonatomic) NSArray<SPPriceUnit *> *units;
@property (strong, nonatomic) SPPriceUnit *minimumUnit;
@property (strong, nonatomic) SPPriceUnit *maximumUnit;

@property (assign, nonatomic) NSInteger curIndex;
@property (strong, nonatomic) SPPriceUnit *curUnit;
@property (strong, nonatomic) SPPriceChartConfig *config;
@property (assign, nonatomic) SPPriceChartLevel level;

@end

@implementation SPPriceChartViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.priceContainerTopConstraint.constant = StatusBar_Height + NaviBar_Height;
    [self.view layoutIfNeeded];
    
    self.nameLabel.text = self.marketItem.name;
    
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    
    self.chartView.headerPadding = 0.f;
    self.chartView.footerPadding = 0.f;
    
    self.chartView.minimumValue = 0.f;
    self.chartView.maximumValue = 100.f;
    
    self.bgView.backgroundColor = [self.item.itemColor colorWithAlphaComponent:0.5f];
    
    [self updateCurPrice];
    
    [self loadPriceData];
}

- (void)setupBestLevel
{
    NSArray *units = [self unitsInLevel:SPPriceChartLevelWeek];
    if (units.count > 7) {
        [self updateLevel:SPPriceChartLevelWeek];
        return;
    }
    
    units = [self unitsInLevel:SPPriceChartLevelMonth];
    if (units.count > 30) {
        [self updateLevel:SPPriceChartLevelMonth];
        return;
    }
    
    units = [self unitsInLevel:SPPriceChartLevelQuarter];
    if (units.count > 30*3) {
        [self updateLevel:SPPriceChartLevelMonth];
        return;
    }
    
    units = [self unitsInLevel:SPPriceChartLevelYear];
    if (units.count > 365) {
        [self updateLevel:SPPriceChartLevelMonth];
        return;
    }
    
    [self updateLevel:SPPriceChartLevelAll];
}

- (void)updateLevel:(SPPriceChartLevel )level
{
    [self rightNavButtonText:LevelString(level)];
    self.level = level;
    self.units = [self unitsInLevel:level];
    self.curUnit = nil;
    
    SPPriceUnit *minimumUnit;
    SPPriceUnit *maximumUnit;
    for (SPPriceUnit *aUnit in self.units) {
        if (!minimumUnit || minimumUnit.price >= aUnit.price) {
            minimumUnit = aUnit;
        }
        if (!maximumUnit || maximumUnit.price <= aUnit.price) {
            maximumUnit = aUnit;
        }
    }
    SPPriceChartConfig *r = LinearTickGenerator(minimumUnit.price, maximumUnit.price, 1, 7);
    self.minimumUnit = minimumUnit;
    self.maximumUnit = maximumUnit;
    self.config = r;
    
    self.minimumDateLabel.text = self.units.firstObject.month_day;
    self.maximumDateLabel.text = self.units.lastObject.month_day;
    
    NSString *(^bestPriceString)(CGFloat p) = ^NSString *(CGFloat p){
        if (p<10.f) {
            return [NSString stringWithFormat:@"%.2f",p];
        }
        if (p < 100) {
            return [NSString stringWithFormat:@"%.1f",p];
        }
        return [NSString stringWithFormat:@"%.0f",p];
    };
    self.minimumPriceLabel.text = bestPriceString(self.config.bottomPrice);
    self.maximumPriceLabel.text = bestPriceString(self.config.topPrice);
    
    [self.view layoutIfNeeded];
    
    [self reloadChartView];
}

- (NSArray<SPPriceUnit *> *)unitsInLevel:(SPPriceChartLevel)level
{
    NSTimeInterval latestTime = self.allUnits.lastObject.timestamp;
    NSTimeInterval spTime = 0;
    switch (level) {
        case SPPriceChartLevelWeek:{
            spTime = latestTime - 7 * 24 * 60 * 60;
        }   break;
        case SPPriceChartLevelMonth:{
            spTime = latestTime - 30 * 24 * 60 * 60;
        }   break;
        case SPPriceChartLevelQuarter:{
            spTime = latestTime - 3 * 30 * 24 * 60 * 60;
        }   break;
        case SPPriceChartLevelYear:{
            spTime = latestTime - 365 * 24 * 60 * 60;
        }   break;
        case SPPriceChartLevelAll:{
            spTime = 0;
        }   break;
    }
    
    if (level == SPPriceChartLevelAll) {
        return self.allUnits;
    }
    
    NSIndexSet *indexes = [self.allUnits indexesOfObjectsWithOptions:NSEnumerationReverse passingTest:^BOOL(SPPriceUnit *obj, NSUInteger idx, BOOL *stop) {
        BOOL pass = obj.timestamp >= spTime;
        *stop = !pass;
        return pass;
    }];
    return [self.allUnits objectsAtIndexes:indexes];
}

- (void)loadPriceData
{
    NSURLComponents *components = [NSURLComponents componentsWithString:self.marketItem.href];
    components.query = nil;
    NSString *URL = components.URL.absoluteString;
    
    [[SPSteamAPI shared] fetchSteamMarketItemDetail:URL completion:^(BOOL suc, NSString *data) {
        if (suc) {
            NSError *error;
            NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"\\[\\[.*\\]\\]" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *checkingResult = [reg firstMatchInString:data options:NSMatchingReportCompletion range:NSMakeRange(0, data.length)];
            
            if (!checkingResult) {
                [self.loading stopAnimating];
                [SVProgressHUD showInfoWithStatus:@"没有价格记录"];
                return;
            }
            
            NSMutableArray *possibleDatas = [NSMutableArray array];
            for (NSInteger i=0; i<checkingResult.numberOfRanges; i++) {
                NSRange range = [checkingResult rangeAtIndex:i];
                NSString *string = [data substringWithRange:range];
                [possibleDatas addObject:string];
            }
            [self didLoadPriceSourceData:possibleDatas];
        }else{
            [self.loading stopAnimating];
            [SVProgressHUD showErrorWithStatus:data];
        }
    }];
}

- (void)didLoadPriceSourceData:(NSArray *)possibleDatas;
{
    RunOnGlobalQueue(^{
        
        NSArray<SPPriceUnit *> *units;
        
        for (NSString *aSources in possibleDatas) {
            
            NSError *error;
            NSArray *tmp = [NSJSONSerialization JSONObjectWithData:[aSources dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            if (error || !tmp || ![tmp isKindOfClass:[NSArray class]]) {
                SPLog(@"解析价格数组出错！error:%@",error);
            }else{
                NSArray *theUnits = [SPPriceUnit unitsWithDatas:tmp];
                if (theUnits.count > 0) {
                    units = theUnits;
                    break;
                }
            }
        }
        
        if (!units) {
            RunOnMainQueue(^{
                [self.loading stopAnimating];
                [SVProgressHUD showErrorWithStatus:@"解析错误，请重试！"];
            });
            return;
        }
        
        self.allUnits = units;
        
        RunOnMainQueue(^{
            
            [self.loading stopAnimating];
            [self setupBestLevel];
            
        });
    });
}

- (void)reloadChartView
{
    self.chartView.minimumValue = self.config.bottomPrice;
    self.chartView.maximumValue = self.config.topPrice;
    [self.chartView reloadDataAnimated:YES];
}

- (void)updateCurPrice
{
    self.priceLabel.text = self.curUnit ? self.curUnit.priceStr : self.marketItem.priceNumber;
    self.descLabel.text = self.curUnit ? self.curUnit.unitDesc : @"当前价格";
}

- (void)doRightNaviBarItemAction
{
    static NSArray *items;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        items = @[[RWDropdownMenuItem itemWithText:LevelString(SPPriceChartLevelWeek) image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:LevelString(SPPriceChartLevelMonth) image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:LevelString(SPPriceChartLevelQuarter) image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:LevelString(SPPriceChartLevelYear) image:nil action:nil],
                  [RWDropdownMenuItem itemWithText:LevelString(SPPriceChartLevelAll) image:nil action:nil]];
    });
    ygweakify(self);
    void (^action)(SPPriceChartLevel level) = ^(SPPriceChartLevel level){
        ygstrongify(self);
        [self updateLevel:level];
    };
    for (RWDropdownMenuItem *item in items) {
        NSUInteger idx = [items indexOfObject:item];
        [item setValue:^{action(idx);} forKey:@"action"];
    }
    
    [RWDropdownMenu presentInPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem presentingFrom:self withItems:items completion:nil];
}

- (void)doLeftNaviBarItemAction
{
    if (self.presentedViewController) {
        ygweakify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            ygstrongify(self);
            [self doLeftNaviBarItemAction];
        }];
    }else{
        [super doLeftNaviBarItemAction];
    }
}

- (void)transitionLayoutToSize:(CGSize)size
{
    RunAfter(.5f, ^{
       [self.chartView reloadDataAnimated:YES];
    });
}

#pragma mark - JBLineChartView dataSource

- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return self.units.count;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dimmedSelectionOpacityAtLineIndex:(NSUInteger)lineIndex
{
    return 1.f;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dimmedSelectionDotOpacityAtLineIndex:(NSUInteger)lineIndex
{
    return 0.f;
}

- (UIView *)lineChartView:(JBLineChartView *)lineChartView dotViewAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldHideDotViewOnSelectionAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
//    return !self.curUnit || self.curIndex != horizontalIndex;
    return NO;
}

#pragma mark - JBLineChartView delegate
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [self.units[horizontalIndex] price];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex
{
    if (self.curUnit) {
        UIView *previousDotView = [lineChartView dotViewAtHorizontalIndex:self.curIndex atLineIndex:lineIndex];
        previousDotView.backgroundColor = [UIColor clearColor];
    }
    UIView *dotView = [lineChartView dotViewAtHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
    dotView.backgroundColor = [UIColor redColor];
    
    
    self.curIndex = horizontalIndex;
    self.curUnit = self.units[horizontalIndex];
    [self updateCurPrice];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldIgnoreSelectionAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView gradientForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView fillGradientForLineAtLineIndex:(NSUInteger)lineIndex
{
    return nil;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [UIColor clearColor];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1.f;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 4.f;
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView
{
    NSInteger count = self.units.count;
    CGFloat width = CGRectGetWidth(lineChartView.frame) / count;
    return MAX(width, 5);
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}

//- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView selectionGradientForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}
//
//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}
//
//- (CAGradientLayer *)lineChartView:(JBLineChartView *)lineChartView selectionFillGradientForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return nil;
//}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [UIColor clearColor];
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView colorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid;
}

- (JBLineChartViewColorStyle)lineChartView:(JBLineChartView *)lineChartView fillColorStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewColorStyleSolid;
}





@end
