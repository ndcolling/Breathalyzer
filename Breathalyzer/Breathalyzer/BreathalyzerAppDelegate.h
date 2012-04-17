//
//  BreathalyzerAppDelegate.h
//  Breathalyzer
//
//  Created by Nathan Collingridge on 3/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiJackMgr.h"

@class BreathalyzerViewController;

@interface BreathalyzerAppDelegate : NSObject <UIApplicationDelegate> {
      HiJackMgr* hiJackMgr;
      UIWindow *window;
      BreathalyzerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BreathalyzerViewController *viewController;

-(int)receive:(UInt8)data;
-(int)sendByte:(UInt8)message;

@end
