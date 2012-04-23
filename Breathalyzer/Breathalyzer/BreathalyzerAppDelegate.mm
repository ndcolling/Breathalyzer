//
//  BreathalyzerAppDelegate.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 3/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BreathalyzerAppDelegate.h"
#import "HiJackMgr.h"
#import "BreathalyzerViewController.h"


@implementation BreathalyzerAppDelegate

@synthesize window = _window;
@synthesize viewController;

const UInt8 ACK = 0x10;
const UInt8 TESTING = 0x10;
const UInt8 ENGAGED = 0x10;


//this function will receive data from hijack
-(int)receive:(UInt8)data
{
    //float sensorValue=(float)data/255;
    //self.viewController.sensorValue = sensorValue;
    
    //NSLog(@"received: x = %i\n", data);
    value = data;
    [viewController fillReceiveTextField:value];
    [self update];
    return 0; 
}

-(BOOL)isOnline
{
    return (state == ONLINE);
}
-(void)update
{
    static int count = 0;
    switch (state)
    {
        case INIT:
            if (value == ACK)
            {
                count++;
            }
            if (count > 3) //received 4 acks indicating that hijack is connected
            {
                //enable test button
                state = ONLINE;
            }
            break;
        case ONLINE:
            if (value == TESTING) //may want to wait until more than 1 TESTING is received.
            {
                state = TEST;
            }
            else if (value != ACK)
            {
                count--;
            }
            if (count < 1)
            {
                //disable button
                state = INIT;
                count = 0;
            }
            break;
        case TEST:
            if (value == ENGAGED)
            {
                state = BUSY;
            }
            break;
        case BUSY: //we may want a protocol (series of values to communicate before the result)
            //value is the value we need to display...
            result = value;
            state = COMPLETE;
            break;
        case COMPLETE:
            //display the results..
            break;
            
    }
}

-(int)sendByte:(UInt8)message
{
    //NSLog(@"sending: x = %i\n", message);

    return [hiJackMgr send:message];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //set initial state
    state = INIT;
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    BreathalyzerViewController *aView = [[BreathalyzerViewController alloc] initWithNibName:@"BreathalyzerViewController" bundle:nil];
    self.viewController = aView;
    [_window addSubview:viewController.view];
    [aView release];
 
    
    //initialize HiJackMgr
    hiJackMgr = [[HiJackMgr alloc] init];
    [hiJackMgr setDelegate:(id)self];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [hiJackMgr release];
    [viewController release];
    [_window release];
    [super dealloc];
}

@end
