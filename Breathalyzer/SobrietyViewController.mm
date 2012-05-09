//
//  SobrietyViewController.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 5/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SobrietyViewController.h"
#import "BreathalyzerAppDelegate.h"

@implementation SobrietyViewController

@synthesize labelX;
@synthesize labelY;
@synthesize labelZ;

@synthesize progressX;
@synthesize progressY;
@synthesize progressZ;

@synthesize accelerometer;

@synthesize startStop;
@synthesize status;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction) updateStatus:(NSString*)theText {
    [self.status performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];    
}
-(IBAction)startStopButtonPressed {
    if (startTest) { //stop the test
        startTest = NO;
        [self.startStop setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.startStop.titleLabel performSelectorOnMainThread : @ selector(setText : ) withObject:@"Start" waitUntilDone:YES];
        
        if (n_cnt < 5) {
            //display sober
            [self.status setTextColor:[UIColor greenColor]];
            [self updateStatus:@"Sober"];
        }
        else if (n_cnt < 8) {
            //display tipsy
            [self.status setTextColor:[UIColor cyanColor]];
            [self updateStatus:@"Tispy"];
        }
        else if (n_cnt < 12) {
            //display inebriated
            [self.status setTextColor:[UIColor yellowColor]];            
            [self updateStatus:@"Inebriated"];
        }
        else if (n_cnt < 18) {
            //display intoxicated
            [self.status setTextColor:[UIColor orangeColor]];            
            [self updateStatus:@"Intoxicated"];
        }
        else {
            //display drunk!
            [self.status setTextColor:[UIColor redColor]];            
            [self updateStatus:@"Drunk!"];
        }
    }
    else { //start the test
        startTest = YES;
        [self.startStop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.startStop.titleLabel performSelectorOnMainThread : @ selector(setText : ) withObject:@"Stop" waitUntilDone:YES];

        n_cnt = 0;
    }
        
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"Sobriety Test";

	UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCancelSignalAndReturn)];
    self.navigationItem.leftBarButtonItem=cancel;

    //accelerometer stuff:
    [super viewDidLoad];
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;    
    
    //test button
    startTest = NO;
    [startStop setTitle:@"Start" forState:UIControlStateNormal];
    [startStop setBackgroundColor:[UIColor greenColor]];
    [startStop setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

    status.text = @"";
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    labelX.text = [NSString stringWithFormat:@"%@%f", @"X: ", acceleration.x];
    labelY.text = [NSString stringWithFormat:@"%@%f", @"Y: ", acceleration.y];
    labelZ.text = [NSString stringWithFormat:@"%@%f", @"Z: ", acceleration.z];
    
    self.progressX.progress = ABS(acceleration.x);
    self.progressY.progress = ABS(acceleration.y);
    self.progressZ.progress = ABS(acceleration.z);
    double curr_x = ABS(acceleration.x);
    double curr_y = ABS(acceleration.y);
    double curr_z = ABS(acceleration.z);
    
    if (startTest && n_cnt == 0) 
    {
        xCache = curr_x;
        yCache = curr_y;
        zCache = curr_z;
        n_cnt = n_cnt + 1;
    }
    //now check if any of the accelerometers have moved beyond 5% of their cached value: (except Z)
    if ( startTest && ( (ABS(xCache - curr_x) > .8 * xCache) || 
                        (ABS(yCache - curr_y) > .8 * yCache)  ) )
                        //(ABS(zCache - curr_z) > .8 * zCache)    ) )
    {
        n_cnt = n_cnt + 1;        
    }
    NSLog(@"n_cnt = %lu",n_cnt);    
}

-(void)sendCancelSignalAndReturn {
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate sendByte:0x14]; //cancel signal
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [startStop release];
    [status release];
    [progressX release];
    [progressY release];
    [progressZ release];
    [labelX release];
    [labelY release];
    [labelZ release];
    [super dealloc];
}

@end
