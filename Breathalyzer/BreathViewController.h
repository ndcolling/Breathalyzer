//
//  BreathViewController.h
//  Breathalyzer
//
//  Created by Nathan Collingridge on 5/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreathViewController : UIViewController {
    IBOutlet UILabel *label;
    IBOutlet UILabel *result;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *result;

-(IBAction) updateLabel:(NSString*)theText;
-(IBAction) updateAndShowResult:(NSString*)theText;

@end
