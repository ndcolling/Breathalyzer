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

typedef enum
{
    INIT,    //initial state
    ONLINE,  //hijack is connected (online)
    TEST,    //user is performing a test
    BUSY,    //test is processing
    COMPLETE //test is finished, final value is received.
} State;

@interface BreathalyzerAppDelegate : NSObject <UIApplicationDelegate> {
      HiJackMgr* hiJackMgr;
      UIWindow *window;
      BreathalyzerViewController *viewController;
      UInt8 value;
      UInt8 result;
      State state;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BreathalyzerViewController *viewController;

-(int)receive:(UInt8)data;
-(int)sendByte:(UInt8)message;
-(void)update;
-(BOOL)isOnline;

@end
