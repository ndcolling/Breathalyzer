//
//  SobrietyViewController.h
//  Breathalyzer
//
//  Created by Nathan Collingridge on 5/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SobrietyViewController : UIViewController <UIAccelerometerDelegate> {
    IBOutlet UILabel *labelX;
    IBOutlet UILabel *labelY;
    IBOutlet UILabel *labelZ;
    
    IBOutlet UIProgressView *progressX;
    IBOutlet UIProgressView *progressY;
    IBOutlet UIProgressView *progressZ;
    
    IBOutlet UIButton *startStop;
    IBOutlet UILabel *status;
    
    BOOL startTest;
    UInt32 n_cnt;
    double xCache;
    double yCache;
    double zCache;
    UIAccelerometer *accelerometer;
}

@property (nonatomic, retain) IBOutlet UILabel *labelX;
@property (nonatomic, retain) IBOutlet UILabel *labelY;
@property (nonatomic, retain) IBOutlet UILabel *labelZ;

@property (nonatomic, retain) IBOutlet UIProgressView *progressX;
@property (nonatomic, retain) IBOutlet UIProgressView *progressY;
@property (nonatomic, retain) IBOutlet UIProgressView *progressZ;

@property (nonatomic, retain) IBOutlet UIButton *startStop;
@property (nonatomic, retain) IBOutlet UILabel *status;

@property (nonatomic, retain) UIAccelerometer *accelerometer;

-(void) sendCancelSignalAndReturn;
-(IBAction)startStopButtonPressed;
-(IBAction) updateStatus:(NSString*)theText;


@end
