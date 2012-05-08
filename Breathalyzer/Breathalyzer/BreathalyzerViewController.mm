//
//  BreathalyzerViewController.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 4/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BreathalyzerViewController.h"
#import "BreathalyzerAppDelegate.h"
#import "SobrietyViewController.h"
#import "BreathViewController.h"

@implementation BreathalyzerViewController


@synthesize breathButton;
@synthesize sobrietyButton;
@synthesize sendButton;
@synthesize sendValue;
@synthesize receiveValue;
@synthesize myLabel;

-(void)enableTestButton
{
    [breathButton setEnabled:YES];
}

-(void)disableTestButton
{
    [breathButton setEnabled:NO];
}

-(void)enableBreathButton {
    [breathButton setEnabled:YES];
}

-(void)disableBreathButton {
    [breathButton setEnabled:NO];
}

- (IBAction) doBreathButton {
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate sendByte:0x11]; // send test signal
    //switch view to test view...
    BreathViewController *theBreathViewController = [[BreathViewController alloc]
                                                      initWithNibName:@"BreathViewController" bundle:nil];
    theBreathViewController.navigationItem.title = @"Breath Test";
    delegate.breathViewController = theBreathViewController;
	[[self navigationController] pushViewController:theBreathViewController animated:YES];
}

- (IBAction) doSobrietyButton {

    SobrietyViewController *sobrietyViewController = [[SobrietyViewController alloc]
                                                    initWithNibName:@"SobrietyViewController" bundle:nil];
    sobrietyViewController.navigationItem.title = @"Sobriety Test";
	[[self navigationController] pushViewController:sobrietyViewController animated:YES];
}

- (IBAction) doSendButton {
    UInt8 value = [sendValue.text intValue];
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate sendByte:value];    
}

-(IBAction) fillReceiveTextField:(UInt8)value {
    NSString *msg = [NSString stringWithFormat:@"%d",value];
    [self.receiveValue performSelectorOnMainThread : @ selector(setText : ) withObject:msg waitUntilDone:YES];    
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
     [self enableBreathButton];
//     [self disableBreathButton];
     self.title = @"Breathalyzer App";
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
