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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"Sobriety Test";

	UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCancelSignalAndReturn)];
    self.navigationItem.leftBarButtonItem=cancel;

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

@end
