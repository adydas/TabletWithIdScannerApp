//
//  QRCodeView.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<ExternalAccessory/ExternalAccessory.h> //Step 3
#import <AudioToolbox/AudioToolbox.h> //Step 3
#import <AVFoundation/AVFoundation.h> //Step 3
#import "uniMag.h"

@interface QRCodeView : UIView{
//**********************for uni mag reader**********************
uniMag *uniReader;  //Step 5



UIAlertView *powerUniMag;
UIAlertView *swipeAlert;

IBOutlet UITextView *textResponse;
IBOutlet UITextView *hexResponse;
IBOutlet UILabel *connectedLabel;

NSString *textResponseOfCard;

//*******************checkin using keypad ************************

IBOutlet UILabel *eventNameLbl;


NSString *eventID;
NSString *eventName;
int sID;
    
    IBOutlet UIButton *qrCodeBtn;
    IBOutlet UIButton *keypadBtn;


}

@property(nonatomic, retain) IBOutlet UITextView *textResponse;
@property(nonatomic, retain) IBOutlet UITextView *hexResponse;
@property(nonatomic, retain) IBOutlet UILabel *connectedLabel;
@property(nonatomic, retain) NSString *textResponseOfCard;
@property(nonatomic,retain)NSString *eventID;
@property(nonatomic,retain)NSString *eventName;

-(void)performCheckinbyStudentID;
-(void)removeOverLay:(NSDictionary*) results;
-(IBAction) swipeCard;
-(IBAction) playTone;
-(void)populateData;
-(void)populateEventName;
+(QRCodeView*) loadInstanceFromNib;


@end
