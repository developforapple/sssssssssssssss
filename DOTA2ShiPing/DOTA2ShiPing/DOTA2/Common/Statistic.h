//
//  Statistic.h
//
//  Created by bo wang on 2016/11/25.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#ifndef Statistic_h
#define Statistic_h

@import AVOSCloud.AVAnalytics;

#define SPBuriedPoint( EventName , LabelText )  [AVAnalytics event: (EventName) label: (LabelText) ]
#define SPBP(e,l) SPBuriedPoint( (e) , (l) )

// AdMob Event
#define Event_AdMob             @"Event_AdMob"
#define Label_AdMob_Received    @"Received"
#define Label_AdMob_Failed      @"Failed"
#define Label_AdMob_Present     @"Present"
#define Label_AdMob_Tapped      @"Tapped"

// GDT Event
#define Event_GDT               @"Event_GDT"
#define Label_GDT_Received      @"Received"
#define Label_GDT_Failed        @"Failed"
#define Label_GDT_Present       @"Present"
#define Label_GDT_Tapped        @"Tapped"


// Item Entrance
#define Event_Item_Entrance     @"Event_Item_Entrance"
// label 为 unit 的 title


#define Event_Dota_Event        @"Event_Dota_Event"
// label 为dota event 的name

// Item
#define Event_Item              @"Event_Item"
// label 为 item 的 name
#define Event_Item_Rarity       @"Event_Item_Rarity"
// label 为 item 的 rarity

// Website
#define Event_Website           @"Event_Website"
// label为 website 的 url 不包含query


#endif /* Statistic_h */
