//
//  BreathViewController.m
//  Breathalyzer
//
//  Created by Nathan Collingridge on 5/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BreathViewController.h"

@implementation BreathViewController

@synthesize label;
@synthesize result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) updateLabel:(NSString*)theText {
    [self.label performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];    
}

-(IBAction) updateAndShowResult:(NSString *)theText {
    [self.result performSelectorOnMainThread : @ selector(setText : ) withObject:theText waitUntilDone:YES];
    [result setHidden:NO];
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
    result.text = @"BAC = ";
    [result setHidden:YES];
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
