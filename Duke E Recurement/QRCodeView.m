//
//  QRCodeView.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QRCodeView.h"
#import "AppDelegate.h"
#import "StudentBO.h"
#import "BLController.h"

@implementation QRCodeView

@synthesize	textResponse;
@synthesize textResponseOfCard;
@synthesize	hexResponse;
@synthesize eventID;
@synthesize eventName;
@synthesize connectedLabel;
static QRCodeView *sharedInstance;

+(QRCodeView*) loadInstanceFromNib { 
    if(sharedInstance!=nil){
        return sharedInstance;
    }
    QRCodeView *result = nil; 
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"QRCodeView" owner:self options:nil];
    for (id anObject in elements) 
    { 
        if ([anObject isKindOfClass:[self class]]) 
        { 
            result = [anObject retain]; 
            break; 
        } 
    } 
    sharedInstance = result;
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

-(void)populateData{
      
    
    
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
	
	powerUniMag = [[UIAlertView alloc] initWithTitle:@"Experience Scanner" 
											 message:@"Powering up Device."
											delegate:self
								   cancelButtonTitle:nil
								   otherButtonTitles:nil];
	
	swipeAlert = [[UIAlertView alloc] initWithTitle:@"Experience Scanner" 
											message:@"Please swipe card."
										   delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:nil];
    
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
	
	UIAlertView *subPreAuth = [[UIAlertView alloc] initWithTitle:@"Scanner Error" 
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
	
	UIAlertView *subPreAuth = [[UIAlertView alloc] initWithTitle:@"Scanner Error" 
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
        
        if ([input rangeOfString:@"Bad"].location != NSNotFound){
            UIAlertView *badSwipe = [[UIAlertView alloc] initWithTitle:@"Swipe Error" 
                                                                 message:@"Please Retry Swipe"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
            [badSwipe show];
            [badSwipe release];
        }else{
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [delegate addDarkView];
            textResponseOfCard = [input retain];
            NSLog(@"textResponseOfCard%@",textResponseOfCard);
            [self performSelectorInBackground:@selector(performGetStudentRequest) withObject:nil];
  
        }
        
    }
    
    [input release];
    input = nil;
}

#pragma mark 
#pragma mark dealloc

- (void)dealloc {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagPoweringNotification" object:nil]; //Step 7
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagTimeoutNotification" object:nil]; //Step 8
	
	[[NSNotificationCenter defaultCenter]removeObserver:self  name:@"uniMagSwipeNotification" object:nil];  //Step 9
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidConnectNotification" object:nil]; //Step 10
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidDisconnectNotification" object:nil];  //Step 11
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagDidReceiveDataNotification" object:nil];  //Step 12
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"uniMagTimeoutSwipe" object:nil]; //Step 13
    
    [uniReader startUniMag:FALSE];
    [uniReader closeConnection];
    
    [uniReader release];
	[powerUniMag release];
	[swipeAlert release];
	[textResponse release];
	[hexResponse release];
    
    [textResponseOfCard release];
    [eventName release];
    [eventID release];
    eventName=eventID=nil;
    
    [super dealloc];
}
-(void)populateEventName{
    eventNameLbl.text= self.eventName;
    [uniReader requestSwipe];
    qrCodeBtn.enabled = NO;
    keypadBtn.enabled = NO;
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
		NSMutableString *serverMessage = [results objectForKey:FailureKey];
        [serverMessage appendString:@" \n "];
        [serverMessage appendString:self.textResponseOfCard];
        NSLog(@"Message %@", serverMessage);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Record Found" 
                                                       message:serverMessage 
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        
		
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
            
            
        }//end if
        else if([tempArray count]==1){
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            [delegate addDarkView];
            StudentBO *tempBO = [tempArray objectAtIndex:0];
            sID = tempBO.studentID;
            [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
            
            
        }//end else
        else  {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Invalid Card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            
        }
        
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
        
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        
		
	}
	else
	{	
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
														message:[results objectForKey:SuccessKey]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		self.hidden= YES;
	}
    
    
}





@end
