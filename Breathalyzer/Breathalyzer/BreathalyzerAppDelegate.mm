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
#import "BreathViewController.h"

@implementation BreathalyzerAppDelegate

@synthesize window = _window;
@synthesize viewController;
@synthesize breathViewController;

//
// These are the commands reveiced from the HiJack
//
const UInt8 ACK = 0x80; // IDLE (HiJack present)
const UInt8 TESTING = 0x83; // TESTING (waiting for breath, 5s timeout)
const UInt8 READING = 0x86; // READING (breath detected, waiting for stable reading)
const UInt8 NOTREADY = 0x89; // NOTREADY (test requested but sensor not yet ready)

//this function will receive data from hijack
-(int)receive:(UInt8)data
{
    //float sensorValue=(float)data/255;
    //self.viewController.sensorValue = sensorValue;
    
    //NSLog(@"received: x = %i\n", data);
    value = data;
  /*
    static UInt8 counter = 0;  
  
    //this tests the null read
    if (counter < 6)
        value = 0x80;
    else if (counter < 8)
        value = 0x89; //testing, waiting for breath 5s timeout
    else if (counter < 10)
        value = 0x89; //no breath detected
    else
        counter = 0;
    counter = counter + 1;
*/
    // This code tests normal operation, you need to manually press the button.
/*
    if (counter < 10)
        value = 0x80;
    else if (counter < 15)
        value = 0x83; //testing, waiting for breath 5s timeout
    else if (counter < 150)
        value = 0x86; //breath detected
    else if (counter < 246)
        value = 15; //value read from the sensor.
    else
        counter = 0;
    counter = counter + 1;
*/
    //value = READING;
    [viewController fillReceiveTextField:value];
    [self update];
    return 0; 
}

-(BOOL)isOnline
{
    return (state == ONLINE);
}

-(NSString*)lookUp:(State)theState {
    switch (state)
    {
        case INIT:    //initial state
            return @"INIT";
        case ONLINE:  //hijack is connected (online)
            return @"ONLINE";
        case TEST:    //user is performing a test
            return @"TEST";
        case COMPLETE: //test is finished, final value is received.
            return @"COMPLETE";
    }
    return @"ERROR";
}

-(void)resetState {
    state = INIT;
}
-(void)update
{
    static int count = 0; 
    //NSLog(@"state = %@",[self lookUp:state]);
    //NSLog(@"value = %x",value);
    switch (state)
    {
        case INIT:
            showAlert = NO;
            if (value == ACK)
            {
                count++;
            }
            if (count > 3) //received 4 acks indicating that hijack is connected
            {
                //enable test button
                [viewController enableBreathButton];
                //NSLog(@"pressing breath button now");
                //[viewController doBreathButton];
                state = ONLINE;
            }
            break;            
        case ONLINE:
            if (value == 0x89) //unable to test, sensor still has alco on it
            {
                [breathViewController updateLabel:@"Unable to test"];
                [breathViewController displayNullReadAlert:@"Sensor still has alcohol gas from previous test. Press cancel and try again."];
            }
            if (value == READING) //may want to wait until more than 1 READING is received.
            {
                //display analyzing
                if (breathViewController != nil)
                {
                    state = TEST;                    
                    //NSLog(@"Updating the label to read Analyzing");
                    [breathViewController updateLabel:@"Analyzing"];
                }
            }
			
			if (value == 0)
			{
				// Show "timeout or no alcohol detected"
				// switch states
                result = 0;
                showAlert = YES;
                state = COMPLETE;
			}
            break;
        case TEST:
            if (value == READING) // Better not wait too long here, if the value is returned quickly it will get stuck. -ds
            {
                if (count < 2)
                    [breathViewController updateLabel:@"Analyzing."];
                else if (count < 4)
                    [breathViewController updateLabel:@"Analyzing.."];
                else if (count < 6)
                    [breathViewController updateLabel:@"Analyzing..."];
                else if (count < 8)
                    [breathViewController updateLabel:@"Analyzing...."];
                else if (count < 10)
                    [breathViewController updateLabel:@"Analyzing....."];
                else
                    count = 0;                
            }
            else if (value < 0x80)
            {
                state = COMPLETE;
				result = value;		
            }
            count++;
            break;
        case COMPLETE:
            //display the result..
            if (breathViewController != nil)
            {   
                double bac = 0;
                if (result < 7)
                    bac = 0.0;
                else if (result < 14)
                    bac = 0.02;
                else if (result < 25)
                    bac = 0.04;
                else if (result < 50)
                    bac = 0.06;
                else if (result < 80)
                    bac = 0.08;
                else if (result < 100)
                    bac = 0.1;
                else if (result < 120)
                    bac = 0.12;
                else if (result < 128)
                    bac = 0.14;
                if (showAlert)
                {
                    [breathViewController displayNullReadAlert:[NSString stringWithFormat:@"No alcohol detected or device timeout. If you have consumed alcohol, please try again."]];
                    showAlert = NO;
                }

                //NSLog(@"bac = %.2f",bac);
                [breathViewController updateLabel:@"DONE!"];
                [breathViewController updateAndShowResult:[NSString stringWithFormat:@"BAC = %.2g",bac]];
            }
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
    breathViewController = nil;
    
    //set initial state
    //NSLog(@"setting state to INIT");
    state = INIT;
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    BreathalyzerViewController *aView = [[BreathalyzerViewController alloc] initWithNibName:@"BreathalyzerViewController" bundle:nil];
    self.viewController = aView;
    
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    [navController release];
    
    //[_window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
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
    [breathViewController release];
    [_window release];
    [super dealloc];
}

@end
