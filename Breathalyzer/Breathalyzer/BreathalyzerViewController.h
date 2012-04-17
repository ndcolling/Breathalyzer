//
//  BreathalyzerViewController.h
//  Breathalyzer
//
//  Created by Nathan Collingridge on 4/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


@interface BreathalyzerViewController : UIViewController{    
	UIButton *breathButton;
	UIButton *sobrietyButton;
    UIButton *sendButton;
    UIButton *switchButton;  
    UIButton *initButton;  
    IBOutlet UITextField *sendValue;
    IBOutlet UITextField *receiveValue;
    IBOutlet UILabel *myLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *breathButton;
@property (nonatomic, retain) IBOutlet UIButton *sobrietyButton;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *switchButton;
@property (nonatomic, retain) IBOutlet UIButton *initButton;
@property (nonatomic, retain) IBOutlet UITextField *sendValue;
@property (nonatomic, retain) IBOutlet UITextField *receiveValue;
@property (nonatomic, retain) IBOutlet UILabel *myLabel;

- (IBAction)doBreathButton;
- (IBAction)doSobrietyButton;
- (IBAction)doSendButton;
- (IBAction)doSwitchButton;
- (IBAction)fillReceiveTextField:(UInt8)value;

@end
