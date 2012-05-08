//
//  BreathalyzerViewController.h
//  Breathalyzer
//
//  Created by Nathan Collingridge on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


@interface BreathalyzerViewController : UIViewController {    
	UIButton *breathButton;
	UIButton *sobrietyButton;
    UIButton *sendButton; 
    UITextField *receiveValue;
    IBOutlet UITextField *sendValue;

    IBOutlet UILabel *myLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *breathButton;
@property (nonatomic, retain) IBOutlet UIButton *sobrietyButton;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UITextField *sendValue;
@property (nonatomic, retain) IBOutlet UITextField *receiveValue;
@property (nonatomic, retain) IBOutlet UILabel *myLabel;

- (IBAction)doBreathButton;
-(void)enableBreathButton;
-(void)disableBreathButton;
- (IBAction)doSobrietyButton;
- (IBAction)doSendButton;
- (IBAction)fillReceiveTextField:(UInt8)value;

@end