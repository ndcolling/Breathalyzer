//
//  BreathViewController.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 5/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BreathViewController.h"
#import "BreathalyzerAppDelegate.h"

@implementation BreathViewController

@synthesize label;
@synthesize result;
@synthesize alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        result = nil;
        label = nil;
        alert = nil;
    }
    return self;
}

-(void)sendCancelSignalAndReturn {
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate sendByte:0x14]; //cancel signal
    [delegate resetState];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction) updateLabel:(NSString*)theText {
    [self.label performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];    
}

-(IBAction) updateAndShowResult:(NSString *)theText {
    [result setHidden:NO];
    [self.result performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];
}

-(IBAction) displayNullReadAlert:(NSString *) theText {

    //NSLog(@"displaying the alert....");
    [alert setHidden:NO];
    [self.alert performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];   

    
    //No alcohol detected or device timeout. If you have consumed alcohol, please try again.

    //Create UIAlertView alert
    //    UIAlertView *myAlert = [[[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
    //    [myAlert show];
    //[alert dismissWithClickedButtonIndex:0 animated:TRUE];
    
    //set up alert:
//    alert = [[UIAlertView alloc] initWithTitle:@"Warning: Timed Out" message:@"No alcohol detected or device timeout. If you have consumed alcohol, please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
  //  [self.alert show];
    //[self.alert release];
    //[[[[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] autorelease] show];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    label.text = @"Breathe into Breathalyzer";
    result.text = @"";
    [result setHidden:YES];
    alert.text = @"";
    //[alert setHidden:YES];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCancelSignalAndReturn)];
    self.navigationItem.leftBarButtonItem=cancel;
    

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
    BreathalyzerAppDelegate *delegate = (BreathalyzerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.breathViewController release];
    [label release];
    [result release];
    [alert release];
    [super dealloc];
}

@end
