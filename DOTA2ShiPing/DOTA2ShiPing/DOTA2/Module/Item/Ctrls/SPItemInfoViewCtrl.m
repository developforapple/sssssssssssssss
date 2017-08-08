//
//  SPItemInfoViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemInfoViewCtrl.h"
#import "SPLogoHeader.h"
#import "SPItem.h"
#import "SPItemStyle.h"
#import "SPItem+Cache.h"
#import "SPDataManager.h"
#import "UIView+Hierarchy.h"
#import "Chameleon.h"
#import "SPItemPriceListViewCtrl.h"
#import "SPBundleItemsViewCtrl.h"

@interface SPItemInfoViewCtrl ()

@property (strong, nonatomic) SPHero *hero;
@property (strong, nonatomic) SPItemPrefab *prefab;
@property (strong, nonatomic) SPItemRarity *rarity;
@property (strong, nonatomic) SPItemQuality *quality;
@property (strong, nonatomic) SPItemSlot *slot;

@property (strong, nonatomic) UIColor *color;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *imagePanel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *titlePanel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) CAGradientLayer *titlePanelBgLayer;

@property (weak, nonatomic) IBOutlet UIView *heroRaritySlotPanel;
@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *rarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotLabel;
@property (strong, nonatomic) CAGradientLayer *HRSPanelBgLayer;

@property (weak, nonatomic) IBOutlet UIView *stylePanel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (strong, nonatomic) CAGradientLayer *stylePanelBgLayer;

@property (weak, nonatomic) IBOutlet UIView *effectPanel;

@property (weak, nonatomic) IBOutlet UIView *pricepanel;
@property (strong, nonatomic) CAGradientLayer *pricePanelBGLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeightConstraint;
@property (strong, nonatomic) SPItemPriceListViewCtrl *priceListViewCtrl;

@property (weak, nonatomic) IBOutlet UIView *bundlePanel;
@property (strong, nonatomic) CAGradientLayer *bundlePanelBGLayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bundleHeightConstraint;
@property (strong, nonatomic) SPBundleItemsViewCtrl *bundleItemsViewCtrl;

@property (weak, nonatomic) IBOutlet UIView *descPanel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) CAGradientLayer *descPanelBgLayer;

@end

@implementation SPItemInfoViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SPLogoHeader setLogoHeaderInScrollView:self.scrollView];
    
    [self loadData];
    
    [self initUI];
    [self updateUI];
}

- (void)loadData
{
    NSArray<SPHero *> *heroes = [[SPDataManager shared] heroesOfNames:[self.item.heroes componentsSeparatedByString:@"|"]];
    SPItemRarity *rarity = [[SPDataManager shared] rarityOfName:self.item.item_rarity];
    SPItemPrefab *prefab = [[SPDataManager shared] prefabOfName:self.item.prefab];
    SPItemQuality *quality = [[SPDataManager shared] qualityOfName:self.item.item_quality];
    SPItemSlot *slot = [[SPDataManager shared] slotOfName:self.item.item_slot];
    UIColor *color = self.item.itemColor;
    
    self.hero = heroes.firstObject;
    self.prefab = prefab;
    self.rarity = rarity;
    self.quality = quality;
    self.slot = slot;
    self.color = color;
}

- (void)initUI
{
    self.imageView.hidden = YES;
}

- (void)updateUI
{
    [self updateImagePanel];
    [self updateTitlePanel];
    [self updateHeroRaritySlotPanel];
    [self updateStylePanel];
    [self updateEffectPanel];
    [self updatePricePanel];
    [self updateBundlePanel];
    [self updateDescPanel];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.titlePanelBgLayer.frame = self.titlePanel.bounds;
    self.stylePanelBgLayer.frame = self.stylePanel.bounds;
    self.descPanelBgLayer.frame = self.descPanel.bounds;
    self.HRSPanelBgLayer.frame = self.heroRaritySlotPanel.bounds;
    self.pricePanelBGLayer.frame = self.pricepanel.bounds;
    self.bundlePanelBGLayer.frame = self.bundlePanel.bounds;
}

- (CAGradientLayer *)gradientLayer
{
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.startPoint = CGPointMake(0, .5f);
    gLayer.endPoint = CGPointMake(1, .5f);
    gLayer.locations = @[@0,@1];
    gLayer.colors = @[(id)[self.color colorWithAlphaComponent:.5f].CGColor,
                      (id)[self.color colorWithAlphaComponent:.1f].CGColor];
    return gLayer;
}

#pragma mark - Update

- (void)updateImagePanel
{
    ygweakify(self);
    [self.imageView sd_setImageWithURL:[self.item qiniuLargeURL] placeholderImage:[UIImage imageNamed:@"HeroPlacehodler"] options:SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageRefreshCached | SDWebImageContinueInBackground | SDWebImageHighPriority  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        ygstrongify(self);
        [self.imageView setHidden:NO animated:YES];
    }];
}

- (void)updateTitlePanel
{
    self.titleLabel.text = self.item.nameWithQualtity;
    
    NSString *rarity = self.rarity.name_loc;
    NSString *type = SPLOCALNONIL(self.item.item_type_name);
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@ %@",rarity,type];
    
    self.titlePanelBgLayer = [self gradientLayer];
    [self.titlePanel.layer insertSublayer:self.titlePanelBgLayer atIndex:0];
}

- (void)updateHeroRaritySlotPanel
{
    //英雄
    SPHero *hero = self.hero;
    [self.heroImageView sd_setImageWithURL:[NSURL URLWithString:[hero smallImageURL]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed | SDWebImageContinueInBackground];
    
    // 稀有度：uncommon
    NSString *rarityTitle = SPLOCAL(@"tag_category_rarity", @"Rarity");
    self.rarityLabel.text = [NSString stringWithFormat:@"%@：%@",rarityTitle,self.rarity.name_loc];
    // 槽位
    NSString *slotTitle = SPLOCAL(@"dota_loadoutslot", @"Slot");
    self.slotLabel.text = [NSString stringWithFormat:@"%@：%@",slotTitle,self.slot.name_loc];
    
    self.HRSPanelBgLayer = [self gradientLayer];
    [self.heroRaritySlotPanel.layer insertSublayer:self.HRSPanelBgLayer atIndex:0];
}

- (void)updateStylePanel
{
    NSArray<SPItemStyle *> *styles = [self.item stylesObjects];
    if (!styles || styles.count == 0){
        //没有款式
        self.stylePanel.collapsed = YES;
        return;
    }
    
    NSDictionary *normalAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDictionary *redAttributes = @{NSForegroundColorAttributeName:FlatWhiteDark};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"款式：" attributes:normalAttributes];
    for (SPItemStyle *aStyle in styles) {
        NSString *text;
        if (!aStyle.name) {
            text = [NSString stringWithFormat:@"\n - 款式：%@",aStyle.index];
        }else{
            NSString *name_loc = SPLOCALNONIL(aStyle.name);
            NSString *title = [NSString stringWithFormat:@"dota_item_%@",aStyle.name];
            NSString *title_loc = SPLOCAL(title, nil);
            if (title_loc.length > 0) {
                text = [NSString stringWithFormat:@"\n - %@：%@",title_loc,name_loc];
            }else{
                text = [NSString stringWithFormat:@"\n - %@",name_loc];
            }
        }
        
        SPItemStyleUnlock *unlock = aStyle.unlock;
        if (unlock) {
            text = [text stringByAppendingString:@"（需要解锁）"];
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:redAttributes]];
        }else{
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:normalAttributes]];
        }
    }
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 4.f;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    self.styleLabel.attributedText = string;
    
    self.stylePanelBgLayer = [self gradientLayer];
    [self.stylePanel.layer insertSublayer:self.stylePanelBgLayer atIndex:0];
}

- (void)updateEffectPanel
{
    self.effectPanel.collapsed = YES;
}

- (void)updatePricePanel
{
    self.priceListViewCtrl.item = self.item;
    self.pricePanelBGLayer = [self gradientLayer];
    [self.pricepanel.layer insertSublayer:self.pricePanelBGLayer atIndex:0];
}

- (void)updateBundlePanel
{
    self.bundlePanel.collapsed = YES;
    self.bundleItemsViewCtrl.item = self.item;
    self.bundlePanelBGLayer = [self gradientLayer];
    [self.bundlePanel.layer insertSublayer:self.bundlePanelBGLayer atIndex:0];
}

- (void)updateDescPanel
{
    NSError *error;
    NSString *desc = SPLOCALNONIL(self.item.item_description);
    NSData *descData = [desc dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithData:descData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:&error];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 4.f;
    [string setAttributes:@{NSForegroundColorAttributeName:FlatWhiteDark,
                            NSFontAttributeName:[UIFont systemFontOfSize:14],
                            NSParagraphStyleAttributeName:style}
                    range:NSMakeRange(0, string.length)];
    self.descLabel.attributedText = string;
    
    self.descPanelBgLayer = [self gradientLayer];
    [self.descPanel.layer insertSublayer:self.descPanelBgLayer atIndex:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SPItemPriceListViewCtrlSegueID"]) {
        self.priceListViewCtrl = segue.destinationViewController;
        ygweakify(self);
        self.priceListViewCtrl.heightDidChanged = ^(CGFloat height) {
            ygstrongify(self);
            [UIView animateWithDuration:.4f animations:^{
                CGFloat pricePanelH = height + self.pricepanel.layoutMargins.top + self.pricepanel.layoutMargins.bottom;
                self.priceHeightConstraint.constant = pricePanelH;
                [self.scrollView layoutIfNeeded];
                
                CGRect frame = self.pricepanel.bounds;
                frame.size.height = pricePanelH;
                self.pricePanelBGLayer.frame = frame;
            }];
        };
    }else if ([segue.identifier isEqualToString:@"SPBundleItemsViewCtrlSegueID"]){
        self.bundleItemsViewCtrl = segue.destinationViewController;
        ygweakify(self);
        self.bundleItemsViewCtrl.heightDidChanged = ^(CGFloat height) {
            ygstrongify(self);
            [UIView animateWithDuration:.4f animations:^{
                CGFloat panelH = height;
                self.bundleHeightConstraint.constant = panelH;
                [self.scrollView layoutIfNeeded];
                
                CGRect frame = self.bundlePanel.bounds;
                frame.size.height = panelH;
                self.bundlePanelBGLayer.frame = frame;
                self.bundlePanel.collapsed = panelH == 0.f;
            }];
        };
    }
}

@end
