//
//  CardReaderInputView.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import "CardReaderInputView.h"
#import "AppDelegate.h"
#import "BLController.h"
#import "SearchStudentView.h"
#import "StudentBO.h"

@implementation CardReaderInputView

@synthesize	textResponse;
@synthesize textResponseOfCard;
@synthesize	hexResponse;
@synthesize eventID;
@synthesize eventName;
@synthesize connectedLabel;
@synthesize checkinConst;

+(CardReaderInputView*) loadInstanceFromNib { 
    CardReaderInputView *result = nil; 
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"CardReaderInputView" owner:self options:nil];
    for (id anObject in elements) 
    { 
        if ([anObject isKindOfClass:[self class]]) 
        { 
            result = anObject; 
            break; 
        } 
    } 
    
    return result; 
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark 
#pragma mark populate Data

-(void)removeObserversOfUniMag{
    [uniReader release];
    uniReader = nil;
	[powerUniMag release];
	[swipeAlert release];
	[textResponse release];
	[hexResponse release];
        
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagPoweringNotification" object:nil]; //Step 7
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagTimeoutNotification" object:nil]; //Step 8
	
	[[NSNotificationCenter defaultCenter]removeObserver:self  name:@"uniMagSwipeNotification" object:nil];  //Step 9
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidConnectNotification" object:nil]; //Step 10
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidDisconnectNotification" object:nil];  //Step 11
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidReceiveDataNotification" object:nil];  //Step 12
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagTimeoutSwipe" object:nil]; //Step 13
    
}
-(void)addObserversOfUniMag{
    
    
    //**************************work for QR Code*************************************
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniPowering:) name:@"uniMagPoweringNotification" object:nil]; //Step 7
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniTimeout:) name:@"uniMagTimeoutNotification" object:nil]; //Step 8
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniSwipe:) name:@"uniMagSwipeNotification" object:nil];  //Step 9
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniAccessoryConnected:) name:@"uniMagDidConnectNotification" object:nil]; //Step 10
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniAccessoryDisconnected:) name:@"uniMagDidDisconnectNotification" object:nil];  //Step 11
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryData:) name:@"uniMagDidReceiveDataNotification" object:nil];  //Step 12
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uniTimeoutSwipe:) name:@"uniMagTimeoutSwipe" object:nil]; //Step 13
	
	
	uniReader = [[uniMag alloc] init]; //Step 6
	[uniReader autoDetect:TRUE];
	[uniReader promptForConnection:TRUE];
	
	powerUniMag = [[UIAlertView alloc] initWithTitle:@"Device Error" 
											 message:@"Powering up UniMag."
											delegate:self
								   cancelButtonTitle:nil
								   otherButtonTitles:nil];
	
	swipeAlert = [[UIAlertView alloc] initWithTitle:@"Device Error" 
											message:@"Please swipe card."
										   delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:nil];
}
-(void)populateData{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if(checkinConst ==1){
        [self addObserversOfUniMag];
        [self addSubview:cardReaderView];
    }
    else {
        
        [self addSubview:keyPadView];
    }
    
    
    eventNameLbl.text= self.eventName;
    eventNameLblCard.text = self.eventName;
    
}

#pragma mark 
#pragma mark uniMag Notifications

- (void)uniPowering:(NSNotification *)notification {  //Step 7
	//This observer is called when the audio tone turns on in an attempt to power the uniMag
	[powerUniMag show];
}



- (void)uniTimeout:(NSNotification *)notification {  //Step 8
	//A timeout happens if a powerering attempt doesn't get a handshake within 5 seconds or a swipe card request doesn't get data within 20 seconds
	
	[powerUniMag dismissWithClickedButtonIndex:0 animated:FALSE];
	[swipeAlert dismissWithClickedButtonIndex:1 animated:FALSE];
	
	UIAlertView *subPreAuth = [[UIAlertView alloc] initWithTitle:@"Device Error" 
														 message:@"Timeout error.  Please verify headphone volume is set to maximum and reconnect the reader again."
														delegate:self
											   cancelButtonTitle:@"Ok"
											   otherButtonTitles:nil];
	[subPreAuth show];
	[subPreAuth release];
    
	[uniReader startUniMag:FALSE];
	
}



- (void)uniTimeoutSwipe:(NSNotification *)notification {  //Step 13
	//A timeout happens if a powerering attempt doesn't get a handshake within 5 seconds or a swipe card request doesn't get data within 20 seconds
	
	[powerUniMag dismissWithClickedButtonIndex:0 animated:FALSE];
	[swipeAlert dismissWithClickedButtonIndex:1 animated:FALSE];
	
	UIAlertView *subPreAuth = [[UIAlertView alloc] initWithTitle:@"Device Error" 
														 message:@"Timeout error.  Please try to swipe card again."
														delegate:self
											   cancelButtonTitle:@"Ok"
											   otherButtonTitles:nil];
	[subPreAuth show];
	[subPreAuth release];
	
    
	
}



- (void)uniSwipe:(NSNotification *)notification {//Step 9
	//When a successful power up attempt is made on a card swipe request	
	
	[powerUniMag dismissWithClickedButtonIndex:0 animated:FALSE];
	
	textResponse.text = @"";
	hexResponse.text = @"";
	[swipeAlert show];
	
}



- (void)uniAccessoryConnected:(NSNotification *)notification {  //Step 10
	//Occurs successful handshake after power up attemp when headphone jack reports device attached
	[powerUniMag dismissWithClickedButtonIndex:0 animated:FALSE];
	connectedLabel.text = @"CONNECTED";
    
}


- (void)uniAccessoryDisconnected:(NSNotification *)notification {  //Step 11
	//Occurs if uniMag was removed from headphone jack
	connectedLabel.text = @"DISCONNECTED";
    
	[uniReader startUniMag:FALSE];
}


- (void)accessoryData:(NSNotification *)notification {  //Step 12
	//returns NSData Object with data from uniMag
	[powerUniMag dismissWithClickedButtonIndex:0 animated:FALSE];
	[swipeAlert dismissWithClickedButtonIndex:1 animated:FALSE];
    
	
	NSData *data = [notification object];
	
	NSString *input = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"%@",input);
    
    if([input length]>0&&input!=nil){
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        [delegate addDarkView];
        textResponseOfCard = [input retain];
        [self removeObserversOfUniMag];
        NSLog(@"textResponseOfCard%@",textResponseOfCard);
        [self performSelectorInBackground:@selector(performGetStudentRequest) withObject:nil];
    }
    
    [input release];
    input = nil;
}

#pragma mark 
#pragma mark dealloc

- (void)dealloc {
    
    [textResponseOfCard release];
    [eventName release];
    [eventID release];
    eventName=eventID=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [super dealloc];
}

#pragma mark 
#pragma mark Uni Mag IBActions

-(IBAction) swipeCard {
	
	[uniReader requestSwipe];
}


-(IBAction) playTone {
	
	[uniReader playTone];
}

#pragma mark 
#pragma mark Alert Views

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
	if (alertView == swipeAlert)
	{
		if (buttonIndex == 0) {
			[uniReader cancelSwipe];
		}
		
	}
    
}

#pragma mark 
#pragma mark checkin by card

-(void)performGetStudentRequest{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"Card Reader Input %@", self.textResponseOfCard);
    
	NSDictionary *dict = [BLController getStudentInformationWithQRCode:self.textResponseOfCard withEventID:[eventID intValue]];
	[self performSelectorOnMainThread:@selector(handleCheckinResponseOfQRCode:) withObject:dict waitUntilDone:NO];
	[pool release];
}

-(void)handleCheckinResponseOfQRCode:(NSDictionary*) results{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];
    
    
    if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"No Student Found."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
        
		
	}
	else
	{	
        NSArray *tempArray = [results objectForKey:SuccessKey];
        if([tempArray count]<=0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"NO Record Found."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self populateData];
            
        }//end if
        else if([tempArray count]==1){
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [delegate addDarkView];
            StudentBO *tempBO = [tempArray objectAtIndex:0];
            sID = tempBO.studentID;
            [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
            if(uniReader){
                [self removeObserversOfUniMag];
            }
            
        }//end else
        else  {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Invalid Card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self populateData];
            
        }
        
	}
}


#pragma mark 
#pragma mark IBActions of USE KepPad 

-(IBAction)checkInBtnPressed:(id)sender{
    
    [self removeKeyBoard];
    NSString *studentID = [studentIDTxt text];
    NSString *studentEmail = [emailTxt text];
    NSString *fName = [fNameTxt text];
    NSString *lName = [lNameTxt text];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate addDarkView];
    
    if([studentID length]>0){
        sID = [[studentIDTxt text] intValue];
        [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
    }
    else if([studentEmail length]>0) {
        [self performSelectorInBackground:@selector(performCheckinbyEmail) withObject:nil];
    }
    else if([fName length]>0&&[lName length]>0){
        
        [self performSelectorInBackground:@selector(performCheckinbyStudentName) withObject:nil];
    }
    else {
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        [delegate removeDarkView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"Please Filled one of Required Field."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self populateData];
        
        
    }
    
}

#pragma mark 
#pragma mark Perform Checkin

-(void)performCheckinbyStudentID{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"student id%i",sID);
	NSDictionary *dict = [BLController checkInStudent:[eventID intValue] withUserID:sID andEmailAddress:@""];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)performCheckinbyStudentName{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *fName = [fNameTxt text];
    NSString *lName = [lNameTxt text];
    
    NSLog(@"event id%@",eventID);
    
	NSDictionary *dict = [BLController getStudent:fName lastName:lName andEventID:[eventID intValue] withOption:2];
	[self performSelectorOnMainThread:@selector(handleCheckinResponseByName:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)performCheckinbyEmail{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *email = [emailTxt text];
    
    
	NSDictionary *dict = [BLController checkInStudent:[eventID intValue] withUserID:0 andEmailAddress:email];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}


-(void)handleCheckinResponseByName:(NSDictionary*) results{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];
    
    
    if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"No Student Found."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
        
		
	}
	else
	{	
        NSArray *tempArray = [results objectForKey:SuccessKey];
        if([tempArray count]<=0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Invalid First Name or Last Name."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self populateData];
            
        }//end if
        else if([tempArray count]==1){
            StudentBO *tempBO = [tempArray objectAtIndex:0];
            sID = tempBO.studentID;
            [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
        }//end else if
        else {
            
            SearchStudentView *tempView = (SearchStudentView*)[SearchStudentView loadInstanceFromNib];
            
            tempView.eventID = [eventID intValue];
            NSLog(@"tempView.eventID %d",tempView.eventID);
            tempView.studentArray = [results objectForKey:SuccessKey];
            NSLog(@"Count of Student Array :%i",[tempView.studentArray count]);
            tempView.frame = CGRectMake(0, 0, 718, 643); 
            [self addSubview:tempView];
        }//end else
        
	}
    
    
}


-(void)removeOverLay:(NSDictionary*) results{    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];
    
    
    if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"No Student Found."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
        
		
	}
	else
	{	
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congragulation" 
														message:[results objectForKey:SuccessKey]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"shouldRemove"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
	}
    
    
}

#pragma mark 
#pragma mark txt Field Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag ==1){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    else if(textField.tag ==2){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    else if(textField.tag ==3||textField.tag==4){
        [scrollView setContentOffset:CGPointMake(0 , 100) animated:YES];
    }
}

#pragma mark 
#pragma mark keyboard show hide methods

-(void)keyboardWillShow {
    [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
}

-(void)keyboardWillHide {
    
    [scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    
}



- (void)removeKeyBoard{
    [self keyboardWillHide];
    [scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [studentIDTxt resignFirstResponder];
    [emailTxt resignFirstResponder];
    [fNameTxt resignFirstResponder];
    [lNameTxt resignFirstResponder];
    
}

#pragma mark 
#pragma mark IBAction of shared btns

-(IBAction)cardReaderBtnPressed:(id)sender{
    if(uniReader){
        [self removeObserversOfUniMag];
    }
    [cardReaderView removeFromSuperview];
    [self addSubview:cardReaderView];
     eventNameLblCard.text= self.eventName;
    [self addObserversOfUniMag];
}
-(IBAction)keyPadBtnPressed:(id)sender{
    [keyPadView removeFromSuperview];
    [self addSubview:keyPadView];
}



@end
