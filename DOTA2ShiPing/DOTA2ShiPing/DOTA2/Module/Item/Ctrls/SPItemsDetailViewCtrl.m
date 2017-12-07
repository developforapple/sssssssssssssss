//
//  SPItemsDetailViewCtrl.m
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/18.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPItemsDetailViewCtrl.h"
#import "SPItemViewCtrl.h"
#import "SPItem.h"
#import "SPPlayerItems.h"

@interface SPItemsDetailViewCtrl ()
@property (strong, nonatomic) SPItemViewCtrl *infoViewCtrl;
@end

@implementation SPItemsDetailViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setItem:(SPItem *)item
{
    _item = item;
    self.infoViewCtrl.item = item;
    SPBP(Event_Item, item.name);
    SPBP(Event_Item_Rarity, item.item_rarity);
}

- (void)setPlayerItem:(SPPlayerItemDetail *)playerItem
{
    _playerItem = playerItem;
    self.infoViewCtrl.playerItem = playerItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SPItemInfoSegueID"]) {
        self.infoViewCtrl = segue.destinationViewController;
        self.infoViewCtrl.item = self.item;
        self.infoViewCtrl.playerItem = self.playerItem;
    }
}

@end
