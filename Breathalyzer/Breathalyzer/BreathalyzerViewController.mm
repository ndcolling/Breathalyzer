//
//  BreathalyzerViewController.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 4/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BreathalyzerViewController.h"
#import "BreathalyzerAppDelegate.h"


@implementation BreathalyzerViewController


@synthesize breathButton;
@synthesize sobrietyButton;
@synthesize sendButton;
@synthesize switchButton;
@synthesize initButton;
@synthesize sendValue;
@synthesize receiveValue;
@synthesize myLabel;

- (IBAction) doBreathButton {
	self.view.backgroundColor = [UIColor blackColor];
}

- (IBAction) doSobrietyButton {
	self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction) doSwitchButton {
    NSLog(@"receiveValue.text = %@",receiveValue.text);
    NSLog(@"sendValue.text = %@",sendValue.text);  
    //exit(0);
    NSString *temp = receiveValue.text;
    receiveValue.text = sendValue.text;
    receiveValue.text = temp;
    
}

- (IBAction) initFields {
    receiveValue.text = @"";
}

- (IBAction) doSendButton {
    UInt8 value = [sendValue.text intValue];
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate sendByte:value];    
}

-(IBAction) fillReceiveTextField:(UInt8)value {
    NSLog(@"filling receive text field with: %d\n",value);
    NSString *msg = [[NSString alloc] initWithFormat:@"%d",value];
    //[receiveValue setText:msg];
    receiveValue.text = msg;
    myLabel.text = msg;
    [msg release];
    //[self loadView];
    //[self viewDidLoad];
}

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

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
*/

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
 {
     [sendValue setKeyboardType:UIKeyboardTypeNumberPad];
     [receiveValue setUserInteractionEnabled:NO];
     //receiveValue.text=@"receive";
     //sendValue.text=@"send";

     [super viewDidLoad];
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

-(void)dealloc
{
    [sendValue release];
    [receiveValue release];
    [sendButton release];
    [breathButton release];
    [sobrietyButton release];
    [super dealloc];
}

@end
