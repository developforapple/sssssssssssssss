//
//  AppDelegate.m
//  SPUpdater
//
//  Created by Jay on 2017/12/5.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "AppDelegate.h"
#import "SPUpdater.h"
#import "SPLogHelper.h"

@interface AppDelegate ()
@property (strong) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *basedataItem;
@property (weak) IBOutlet NSMenuItem *langItem;
@property (weak) IBOutlet NSMenuItem *langpatchItem;
@property (weak) IBOutlet NSMenuItem *checkDelayTimeItem;
@property (weak) IBOutlet NSMenuItem *lastCheckTimeItem;
@property (weak) IBOutlet NSMenuItem *nextCheckTimeItem;
@property (weak) IBOutlet NSMenuItem *lastUpdateTimeItem;
@property (weak) IBOutlet NSMenuItem *checkUpdateItem;
@property (weak) IBOutlet NSMenuItem *updateItem;
@property (weak) IBOutlet NSMenuItem *oldServiceItem;
@property (weak) IBOutlet NSMenuItem *adServiceItem;
@property (weak) IBOutlet NSMenuItem *proServiceItem;
@property (weak) IBOutlet NSMenuItem *logItem;
@property (weak) IBOutlet NSMenuItem *curLogItem;
@property (weak) IBOutlet NSMenuItem *quititem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SPLog(@"applicationDidFinishLaunching");
    [self initStatusItem];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initStatusItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"Icon"]];
    self.statusItem.menu = self.statusMenu;
    [self updateServiceMenuItems];
}

- (void)updateTimeMenuItems
{
    
}

- (void)updateServiceMenuItems
{
    self.oldServiceItem.state = [SPUpdater updater].state.oldServiceOn ? NSControlStateValueOn  : NSControlStateValueOff ;
    self.adServiceItem.state = [SPUpdater updater].state.adServiceOn ? NSControlStateValueOn  : NSControlStateValueOff ;
    self.proServiceItem.state = [SPUpdater updater].state.proServiceOn ? NSControlStateValueOn  : NSControlStateValueOff ;
}

- (IBAction)checkUpdateAction:(id)sender
{
    SPLog(@"手动检查更新");
    [[SPUpdater updater] start];
}

- (IBAction)updateAction:(id)sender
{
    SPLog(@"手动强制更新");
    
}

- (IBAction)oldServiceAction:(id)sender
{
    SPUpdaterState *state = [SPUpdater updater].state;
    state.oldServiceOn = !state.oldServiceOn;
    [self updateServiceMenuItems];
    SPLog(@"Old Service turn %@",state.oldServiceOn ? @"ON" : @"OFF");
}

- (IBAction)adServiceAcTION:(id)sender
{
    SPUpdaterState *state = [SPUpdater updater].state;
    state.adServiceOn = !state.adServiceOn;
    [self updateServiceMenuItems];
    SPLog(@"AD Service turn %@",state.adServiceOn ? @"ON" : @"OFF");
}

- (IBAction)proServiceAction:(id)sender
{
    SPUpdaterState *state = [SPUpdater updater].state;
    state.proServiceOn = !state.proServiceOn;
    [self updateServiceMenuItems];
    SPLog(@"PRO Service turn %@",state.proServiceOn ? @"ON" : @"OFF");
}

- (IBAction)openLogFile:(id)sender
{
    
}

- (IBAction)showCurLog:(id)sender
{
    
}

@end
