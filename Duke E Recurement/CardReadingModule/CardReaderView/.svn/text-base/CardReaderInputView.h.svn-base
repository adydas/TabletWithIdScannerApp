//
//  CardReaderInputView.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<ExternalAccessory/ExternalAccessory.h> //Step 3
#import <AudioToolbox/AudioToolbox.h> //Step 3
#import <AVFoundation/AVFoundation.h> //Step 3
#import "uniMag.h" 

@interface CardReaderInputView : UIView
{
    
    IBOutlet UIView *cardReaderView;
    IBOutlet UIView *keyPadView;
    

    //**********************for uni mag reader**********************
    uniMag *uniReader;  //Step 5
    
	
	
	UIAlertView *powerUniMag;
	UIAlertView *swipeAlert;
	
	IBOutlet UITextView *textResponse;
	IBOutlet UITextView *hexResponse;
	IBOutlet UILabel *connectedLabel;
    
    NSString *textResponseOfCard;
    
    //*******************checkin using keypad ************************
    IBOutlet UITextField *studentIDTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *fNameTxt;
    IBOutlet UITextField *lNameTxt;
    
    IBOutlet UILabel *eventNameLbl;
    IBOutlet UILabel *eventNameLblCard;
    IBOutlet UIScrollView *scrollView;
    
    NSString *eventID;
    NSString *eventName;
    int sID;
    
    int checkinConst;

    
}
-(IBAction) swipeCard;
-(IBAction) playTone;
-(void)populateData;
-(void)addObserversOfUniMag;
-(void)removeObserversOfUniMag;

@property(nonatomic, retain) IBOutlet UITextView *textResponse;
@property(nonatomic, retain) IBOutlet UITextView *hexResponse;
@property(nonatomic, retain) IBOutlet UILabel *connectedLabel;
@property(nonatomic, retain) NSString *textResponseOfCard;


+(CardReaderInputView*) loadInstanceFromNib;


//*******************checkin using keypad ************************

@property(nonatomic,retain)NSString *eventID;
@property(nonatomic,retain)NSString *eventName;
@property(nonatomic, readwrite) int checkinConst;

-(void)performCheckinbyStudentID;
-(void)performCheckinbyStudentName;
-(void)performCheckinbyEmail;
-(void)removeOverLay:(NSDictionary*) results;
-(void)populateData;
- (void)removeKeyBoard;
-(void)keyboardWillShow; 
-(void)keyboardWillHide;

@end
